# aws

AWS CLI configuration. Only `~/.aws/config` is versioned — credentials never touch this repo.

---

## What's included

```
aws/
└── .aws/
    └── config   — output format, region defaults, SSO profile templates
```

## Security boundary

| File | Versioned | Contains |
|------|-----------|---------|
| `~/.aws/config` | Yes — this repo | Named profiles, SSO session, region, output format |
| `~/.aws/credentials` | Never | Access key ID + secret (gitignored globally) |

## Setting up SSO profiles

1. Uncomment and fill in the profile blocks in `.aws/config`:

   ```ini
   [profile dev]
   sso_session      = my-sso
   sso_account_id   = 123456789012
   sso_role_name    = AdministratorAccess
   region           = us-east-1
   output           = json
   ```

2. Uncomment the `[sso-session]` block and set your org's SSO start URL:

   ```ini
   [sso-session my-sso]
   sso_start_url        = https://YOUR_ORG.awsapps.com/start
   sso_region           = us-east-1
   sso_registration_scopes = sso:account:access
   ```

3. Log in:

   ```bash
   aws sso login --profile dev
   ```

4. Verify:

   ```bash
   awsp dev        # sets AWS_PROFILE=dev and prints caller identity
   awsid           # aws sts get-caller-identity
   ```

## Switching profiles

```bash
awsp <profile-name>    # defined in zsh/conf.d/aliases.zsh
```

`awsp` exports `AWS_PROFILE` and immediately runs `aws sts get-caller-identity` so you know which account you're in.

## Adding a new account

Copy any existing `[profile ...]` block, change the `sso_account_id` and `sso_role_name`, and run `aws sso login --profile <new-profile>`. The shared `[sso-session]` block handles the token — no need to re-authenticate if the session is still valid.
