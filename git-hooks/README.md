# Git Chinese Character Check Hooks

Git hooks that check for Chinese characters in code and commit messages, automatically blocking commits when non-i18n Chinese content is detected.

## Features

- **Pre-commit Hook**: Scans staged code files for Chinese characters
  - Supports multiple file types: JS/TS, Python, Java, Go, Rust, C/C++, CSS/SCSS, Vue, JSON, YAML
  - Automatically excludes common i18n patterns:
    - `t('中文')`, `$t('中文')`, `i18n.t('中文')`
    - `formatMessage({defaultMessage: '中文'})`
    - `trans('中文')`, `gettext('中文')`, `_('中文')`
  - Reports exact line numbers and content with violations

- **Commit-msg Hook**: Validates commit messages for Chinese characters
  - Shows which lines contain Chinese
  - Displays the actual Chinese characters found

## Installation

### Method 1: Using the install script (Recommended)

The install script supports selective installation of hooks:

```bash
# Install all hooks (default)
bash git-hooks/install.sh

# Install only code check (pre-commit hook)
bash git-hooks/install.sh --code

# Install only message check (commit-msg hook)
bash git-hooks/install.sh --msg

# Show help
bash git-hooks/install.sh -h
```

| Parameter | Description | Hooks Installed |
|-----------|-------------|-----------------|
| (none) | Install all hooks | pre-commit + commit-msg |
| `--all` | Install all hooks | pre-commit + commit-msg |
| `--code` / `--pre-commit` | Code check only | pre-commit |
| `--msg` / `--commit-msg` | Message check only | commit-msg |
| `-h` / `--help` | Show help | - |

### Method 2: Manual installation

```bash
# Copy hooks to .git/hooks
cp git-hooks/pre-commit .git/hooks/
cp git-hooks/commit-msg .git/hooks/

# Make them executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/commit-msg
```

### Method 3: Global installation (for all repositories)

```bash
# Configure git to use a global hooks directory
git config --global core.hooksPath ~/.git-hooks

# Copy hooks to the global directory
mkdir -p ~/.git-hooks
cp git-hooks/pre-commit ~/.git-hooks/
cp git-hooks/commit-msg ~/.git-hooks/
chmod +x ~/.git-hooks/pre-commit
chmod +x ~/.git-hooks/commit-msg
```

## Usage

### Normal commit

```bash
git add .
git commit -m "feat: add user authentication feature"
# Hooks will run and check for Chinese characters
```

### When Chinese characters are detected

#### In code:
```
Running pre-commit Chinese character check...

Chinese characters found in: src/utils/helper.js
  Line 42: const message = "这是一个错误信息";
  Line 45: // 这里是中文注释

Commit blocked: Chinese characters found in code.
Please remove Chinese characters or move them to i18n files.
Common i18n patterns like t(), $t(), i18n.t() are automatically excluded.
```

#### In commit message:
```
Running commit-msg Chinese character check...

Chinese characters found in commit message!
Commit message:
feat: 添加用户登录功能

Violations:
  Line 1: feat: 添加用户登录功能
    Found Chinese: 添加 用户 登录 功能

Please use English for commit messages.
Example: 'feat: add user authentication feature'
```

### Skipping hooks (not recommended)

If you need to bypass the hooks temporarily:

```bash
git commit --no-verify -m "your message"
```

## Supported i18n Patterns

The following patterns are automatically excluded from Chinese character checks:

| Pattern | Example |
|---------|---------|
| `t('中文')` | `t('保存成功')` |
| `$t('中文')` | `$t('保存成功')` |
| `i18n.t('中文')` | `i18n.t('保存成功')` |
| `formatMessage({...})` | `formatMessage({defaultMessage: '保存成功'})` |
| `trans('中文')` | `trans('保存成功')` |
| `gettext('中文')` | `gettext('保存成功')` |
| `_('中文')` | `_('保存成功')` |

## File Types Checked

- JavaScript: `.js`, `.jsx`
- TypeScript: `.ts`, `.tsx`
- Python: `.py`
- Java: `.java`
- Go: `.go`
- Rust: `.rs`
- C/C++: `.c`, `.cpp`, `.h`
- CSS: `.css`, `.scss`, `.less`
- Vue: `.vue`
- Config: `.json`, `.yaml`, `.yml`

## Uninstallation

```bash
bash git-hooks/uninstall.sh
```

Or manually remove:

```bash
# Remove all hooks
rm -f .git/hooks/pre-commit .git/hooks/commit-msg

# Or remove specific hook
rm -f .git/hooks/pre-commit      # Remove code check only
rm -f .git/hooks/commit-msg      # Remove message check only
```

## Requirements

- Bash shell (compatible with macOS and Linux)
- Git
- Python 3 (for Chinese character detection)
- `grep` with `-E` (extended regex) support

## License

MIT
