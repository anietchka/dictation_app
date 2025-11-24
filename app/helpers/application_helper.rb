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

  def sortable_column(column, label, current_sort, current_direction)
    direction = if current_sort == column && current_direction == "asc"
                  "desc"
    else
                  "asc"
    end

    icon = if current_sort == column
             if current_direction == "asc"
               "↑"
             else
               "↓"
             end
    else
             "⇅"
    end

    link_to(
      "#{label} <span class='text-[#3A7BD5]'>#{icon}</span>".html_safe,
      dictations_path(sort_by: column, direction: direction),
      class: "flex items-center gap-1 hover:text-[#3A7BD5] transition-colors text-[#777777]"
    )
  end
end
