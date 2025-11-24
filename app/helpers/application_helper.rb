module ApplicationHelper
  def dictation_levels
    [
      "CP",
      "CE1",
      "CE2",
      "CM1",
      "CM2",
      "6ème",
      "5ème",
      "4ème",
      "3ème",
      "2nde",
      "1ère",
      "Terminale",
      "Études supérieures"
    ]
  end

  def locale_flag(locale)
    flags = {
      fr: "🇫🇷",
      en: "🇬🇧"
    }
    flags[locale.to_sym] || "🌐"
  end
end
