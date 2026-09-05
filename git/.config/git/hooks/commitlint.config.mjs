/**
 * commitlint - commit headers
 * - with a ticket:     JIRA-1: Subject
 * - without a ticket:  type(scope): Subject
 * - header <=72 chars, capital after colon
 * - body: blank line after header, wrap at 72, explain motivation/context
 * - breaking changes: ! before the colon, or BREAKING CHANGE footer
 */

const CONVENTIONAL = /^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\(.+\))?!?: (.+)/;
const TICKET = /^[A-Z][A-Z0-9]+-\d+!?: .+/;
const TICKET_ID = /^[A-Z][A-Z0-9]+-\d+$/;

export default {
  parserPreset: {
    parserOpts: {
      // hyphenated ticket IDs and `!` breaking keep working across shells
      // (v21 default parserOpts parse neither)
      headerPattern: /^([A-Za-z][A-Za-z0-9-]*)(?:\(([^)]*)\))?!?: (.+)$/,
      headerCorrespondence: ["type", "scope", "subject"],
    },
  },
  plugins: [
    {
      rules: {
        "header-conventional-or-ticket": (parsed) => {
          const header = (parsed.header || "").trim();
          if (!header) return [false, "header may not be empty"];
          if (TICKET.test(header)) return [true, ""];
          if (CONVENTIONAL.test(header)) {
            // a ticket may not hide in the scope slot - use it as the whole prefix
            if (parsed.scope && TICKET_ID.test(parsed.scope)) return [false, "use the ticket as the whole prefix: `JIRA-1: Subject`"];
            return [true, ""];
          }
          return [false, "header must be `JIRA-1: Subject` or `type(scope): Subject`"];
        },
        "subject-capitalized": (parsed) => {
          const subject = (parsed.subject || "").trim();
          return [/^[A-Z]/.test(subject), "subject must start with a capital letter"];
        },
      },
    },
  ],
  rules: {
    // header - ticket or conventional form
    "header-conventional-or-ticket": [2, "always"],
    // subject - aim 50, hard 72, first letter capitalized
    "header-max-length": [2, "always", 72],
    "header-min-length": [2, "always", 10],
    "subject-capitalized": [2, "always"],
    // built-in type/scope/subject-case rules are superseded by the custom rules above;
    // built-in parser needs the parserPreset override even with built-ins off
    "type-enum": [0, "always", []],
    "type-case": [0, "never"],
    "type-empty": [0, "never"],
    "scope-case": [0, "never"],
    "scope-empty": [0, "never"],
    "subject-case": [0, "never"],
    "subject-empty": [2, "never"],
    "subject-full-stop": [2, "never", "."],
    // body - blank line before, wrap at 72
    "body-leading-blank": [2, "always"],
    "body-max-line-length": [1, "always", 72],
    "footer-leading-blank": [2, "always"],
    "footer-max-line-length": [1, "always", 72],
  },
};
