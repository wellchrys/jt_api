import { danger, fail } from "danger";

const {
  git: { diffForFile, modified_files: modifiedFiles, created_files: newFiles },
  github: { pr },
} = danger;

const changedFiles = [...modifiedFiles, ...newFiles];
const elixirFiles = changedFiles.filter((f) => f.match(/.ex$/));
const routerFiles = changedFiles.filter((f) => f.match(/router.ex$/));
const elixirTestFiles = changedFiles.filter((f) => f.match(/test\/just\/|test\/just_web\//));
const queryFiles = changedFiles.filter((file) =>
  file.match(/(query.ex)|(queries.ex)$/)
);

const migrationsPath = "priv/repo/migrations";
const testDirectories = [
  "test/",
];
const modifiedLibFiles = changedFiles.filter((f) => f.includes("lib/"));
const hasLibChanges = modifiedLibFiles.length > 0;
const nonInternalLibFiles = elixirFiles.filter(
  (f) => !f.match("lib/just/")
);

const checks = [
  async function ensurePackageChanges() {
    const packageModified = modifiedFiles.some((file) =>
      file.match(/package\.json$/)
    );
    const packageLockModified = modifiedFiles.some((file) =>
      file.match(/yarn-lock$/)
    );

    if (packageModified && !packageLockModified) {
      warn(
        "package.json was updated without updating yarn.lock. Please ensure you've run yarn and committed the changes to yarn.lock."
      );
    }
  },
  async function ensureEnumValuesAsString() {
    const diffs = elixirFiles.map((file) => diffForFile(file));
    const enumFound = (await Promise.all(diffs)).some(({ added }) =>
      /defenum/gm.test(added)
    );

    if (enumFound) {
      warn(`Please, make sure Enum values were defined as 'String'; e.g.
        # preferred
        defenum(MyEnum, foo: "foo", bar: "bar")
        # preferred
        defenum(MyEnum, [foo, bar])
        # not preferred
        defenum(MyEnum, foo: 0, bar: 1)
      `);
    }
  },
  async function ensurePreloadLookupPreference() {
    const diffs = modifiedLibFiles.map((file) => diffForFile(file));

    const preloadFound = (await Promise.all(diffs)).some(({ added }) =>
      /Repo\.preload/gm.test(added)
    );

    if (preloadFound) {
      const single =
        "\n# single SQL query\Just.Users.User\n|> join(:inner, [u], o in assoc(u, :group_customer))\n|> Ecto.Query.where([u], u.id == 1)\n|> Ecto.Query.preload([u, o], ticket: o)\n|> Repo.one!()";
      const multiple =
        "\n# multiple SQL queries\Just.Users.User\n|> Ecto.Query.where([u], u.id == 1)\n|> Repo.one!()\n|> Repo.preload(:ticket)";

      warn(
        `Consider if preloading using lookup (join) would be more performant (it may not always be), e.g:\n\n${"```elixir"}${single}\n${multiple}\n${"```"}`
      );
    }
  },
  async function ensureEctoIsOnlyUsedByBLOM() {
    const diffs = nonInternalLibFiles
      .filter(
        (file) =>
          !/test\//gm.test(file)
      )
      .map((file) => diffForFile(file));

    const inappropriateEctoUsageFound = (
      await Promise.all(diffs)
    ).some(({ added }) => /import Ecto/gm.test(added));

    if (inappropriateEctoUsageFound) {
      fail("Ecto should only be used by BLOM modules!");
    }
  },
  async function ensureChangesetIsOnlyUsedByBLOM() {
    const diffs = nonInternalLibFiles
      .filter(
        (file) =>
          !/test\//gm.test(file)
      )
      .map((file) => diffForFile(file));

    const inappropriateChangesetUsageFound = (
      await Promise.all(diffs)
    ).some(({ added }) => /changeset\(/gm.test(added));

    if (inappropriateChangesetUsageFound) {
      warn("Changeset should only be used by BLOM modules!");
    }
  },
  async function suggestNamedBindingForQueries() {
    const diffs = queryFiles.map((file) => diffForFile(file));
    const regex = /join.+[as:|assoc].+/gm;
    const regex2 = /.+(\[.+\:.+\]).+/gm;
    const namedBindingFound = (await Promise.all(diffs)).some(
      ({ added }) => regex.test(added) || regex2.test(added)
    );

    if (queryFiles.length > 0 && !namedBindingFound) {
      warn(
        "Please use [named binding](https://hexdocs.pm/ecto/Ecto.Query.html#module-named-bindings) in Query and/or Queries modules. "
      );
    }
  },
  async function flagSensitiveDatabaseChanges() {
    const diffs = newFiles
      .filter((file) => file.includes(migrationsPath))
      .map((file) => diffForFile(file));

    // migration.down method should be somehow ignored

    const migrationsRegex = {
      dropTable: /(drop table)|(drop\(table)/gm,
      renameColumn: /(rename table)|(rename\(table)/gm,
      removeColumn: /(remove :)|(remove\()/gm,
      modifyColumn: /(modify :)|(modify\()/gm,
    };

    const { dropTable, renameColumn, removeColumn, modifyColumn } = (
      await Promise.all(diffs)
    ).reduce(
      ({ dropTable, renameColumn, removeColumn, modifyColumn }, { added }) => {
        let addedContent = added.replace(/\+/g, "");

        if (/def down/gm.test(addedContent)) {
          const down = addedContent.substring(
            addedContent.indexOf("def down do\n"),
            addedContent.indexOf("def down do\n") + addedContent.length
          );
          const afterDown = down.substring(
            down.indexOf("end\n") + 4,
            down.length
          );
          const beforeDown = addedContent.substring(
            0,
            addedContent.indexOf("def down do\n")
          );

          addedContent = beforeDown + afterDown;
        }

        return {
          dropTable: !dropTable
            ? migrationsRegex.dropTable.test(addedContent)
            : dropTable,
          renameColumn: !renameColumn
            ? migrationsRegex.renameColumn.test(addedContent)
            : renameColumn,
          removeColumn: !removeColumn
            ? migrationsRegex.removeColumn.test(addedContent)
            : removeColumn,
          modifyColumn: !modifyColumn
            ? migrationsRegex.modifyColumn.test(addedContent)
            : modifyColumn,
        };
      },
      {
        dropTable: false,
        renameColumn: false,
        removeColumn: false,
        modifyColumn: false,
      }
    );

    const hasSensitiveMigrations =
      dropTable || renameColumn || removeColumn || modifyColumn;

    if (hasSensitiveMigrations) {
      warn(
        `This PR has some sensitive Database changes:\n\n **drop table** ${
          dropTable ? ":+1:" : ":-1:"
        } \n **rename column** ${
          renameColumn ? ":+1:" : ":-1:"
        } \n **remove column** ${
          removeColumn ? ":+1:" : ":-1:"
        } \n **modify column** ${modifyColumn ? ":+1:" : ":-1:"}`
      );
    }

    if (hasSensitiveMigrations && hasLibChanges) {
      warn("Sensitive migrations should be moved to a different PR.");
    }
  },
  async function discourageLibUsageOnMigrations() {
    const diffs = newFiles
      .filter((file) => file.includes(migrationsPath))
      .map((file) => diffForFile(file));

    const libUsageFound = (await Promise.all(diffs)).some(({ added }) =>
      added.match(/alias Just\.*/g)
    );

    if (libUsageFound) {
      fail("Lib usage on migrations should be avoided.");
    }
  },
  async function lineDeltaWithoutTests() {
    const diffs = changedFiles
      .filter((file) => !testDirectories.some((path) => file.includes(path)))
      .map((file) => diffForFile(file));

    const { added, removed } = (await Promise.all(diffs)).reduce(
      ({ added, removed }, diff) => ({
        added: (diff.added ? diff.added.split("\n").length : 0) + added,
        removed: (diff.removed ? diff.removed.split("\n").length : 0) + removed,
      }),
      { added: 0, removed: 0 }
    );

    message(
      `LoC delta (excluding files in test directories): ${added} lines were added and ${removed} lines were removed`
    );
  },
  async function ensureElixirPublicMethodsWillHaveSpecs() {
    const diffs = elixirFiles.map(diffForFile);

    const newPublicMethodFound = (await Promise.all(diffs)).some(({ added }) =>
      added.match(/def (.*) do/g)
    );

    if (newPublicMethodFound) {
      warn(
        "There are public methods added. Don't forget to properly add [Specs](https://hexdocs.pm/elixir/typespecs.html) for them."
      );
    }
  },
  async function deployerNoteAboutEnvOrConfigChanges() {
    const envFiles = changedFiles.filter((f) =>
      f.match(/\.env|config\/*.exs/g)
    );
    const hasEnvFilesChanges = envFiles.length > 0;

    if (hasEnvFilesChanges) {
      warn("Deployer, note that there are env or config changes!");
    }
  },
  async function deployerNoteAboutMigrationsChanges() {
    const migrationFiles = changedFiles.filter((f) =>
      f.includes(migrationsPath)
    );
    const hasMigrationFilesChanges = migrationFiles.length > 0;

    if (hasMigrationFilesChanges) {
      warn("Deployer, note that there are migration changes!");
    }

    const hasNewMigrations = newFiles.filter((f) => f.includes(migrationsPath));

    if (hasNewMigrations.length > 0) {
      warn("Deployer, note that there are NEW migrations.");
    }
  },
  async function encourageDocumentationForEnvVars() {
    const envFile = changedFiles.filter((f) => f.includes(".env"));
    const hasEnvFileChanges = envFile.length > 0;

    if (hasEnvFileChanges) {
      warn(
        "There are environment variables changes. Don't forget to add a few notes about them in the project README.md."
      );
    }
  },
  async function encourageMoreTesting() {
    const testChanges = changedFiles.filter((f) => f.includes("test"));
    const hasTestChanges = testChanges.length > 0;

    if (hasLibChanges && !hasTestChanges) {
      warn(
        "There are library changes, but not tests. That's OK as long as you're changing docs, specs, or non testable code unities."
      );
    }
  },
  async function encourageSmallerPRs() {
    const bigPRThreshold = 1000;

    if (pr.additions + pr.deletions > bigPRThreshold) {
      warn(":exclamation: Big PR");
      markdown(
        "> Pull request size seems relatively large. If this pull request contains multiple changes, splitting each change into a separate PR will make for a faster and easier review."
      );
    }
  },
  async function makeSureShortcutCaseInPRTitle() {
    if (!pr.title.match(/\[sc-[0-9]+\]/g)) {
      fail(
        "Please make sure you add the shortcut story number in the PR title with a format of [sc-XXXX]." +
          "It is recommended to have it to be unique and has never been associated with another Github PR."
      );
    }
  },
  async function makeSureShortcutLinkInPRBody() {
    if (
      !pr.body.match(/https:\/\/app\.shortcut\.com\/story\/[0-9]+/g)
    ) {
      fail(
        "Please make sure you add the shortcut story URL in the PR body with https://app.shortcut.com/story/[XXXX]." +
          "It is recommended to have it to be unique and has never been associated with another Github PR."
      );
    }
  },
  async function ensureRestfulRoutes() {
    const diffs = routerFiles.map(diffForFile);
    const nonRestfulRoutesFound = (await Promise.all(diffs)).some(({ added }) =>
      added.match(/(post|put|delete|get)(\(\")(((?!:).)*)\,.*\)/gm)
    );
    if (nonRestfulRoutesFound) {
      warn(`There are new routes added in router.ex, but some of them does not seem to be following RESTful Conventions.
          Maybe consider using [resources](https://hexdocs.pm/phoenix/Phoenix.Router.html#resources/4).`);
    }
  },
  async function ensureTestFilesProperlyNaming() {
    elixirTestFiles.find((fileName) => {
      if (!fileName.match(/_test.exs$/)) {
        fail(
          "There are test files with the wrong naming - " + fileName
        );
      }
    });
  }
];

(async () => {
  checks.map(async (check) => await check());
})();
