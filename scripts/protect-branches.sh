#!/usr/bin/env bash
# Protège main et dev sur GitHub : pas de push direct, PR obligatoire, 1 approbation.
# Usage : ./scripts/protect-branches.sh <owner>/<repo>
# Prérequis : gh auth login, droits admin sur le dépôt.
set -euo pipefail
REPO="${1:?Usage: $0 owner/repo}"

for BRANCH in main dev; do
  echo "Protection de $BRANCH..."
  gh api -X PUT "repos/$REPO/branches/$BRANCH/protection" \
    -H "Accept: application/vnd.github+json" \
    --input - <<'JSON'
{
    "required_status_checks": { "strict": true, "contexts": ["quality"] },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": 1,
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true
}
JSON
done

gh api -X PATCH "repos/$REPO" -f default_branch=dev >/dev/null
echo "OK : main et dev protégées, branche par défaut = dev"
