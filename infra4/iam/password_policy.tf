resource "aws_iam_account_password_policy" "secure_password_policy" {
  minimum_password_length        = 14
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  require_symbols                = true
  allow_users_to_change_password = true

  # Forcer les utilisateurs à changer leur mot de passe périodiquement
  max_password_age                = 90   # jours
  password_reuse_prevention       = 5    # impossible de réutiliser les 5 derniers mots de passe
  hard_expiry                     = false # utilisateur bloqué seulement après expiration + délai de grâce

}
