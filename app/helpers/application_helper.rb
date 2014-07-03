module ApplicationHelper

    def sortable(table, column, title = nil)
      title ||= column.titleize
      css_class = (table + "." + column == sort_column) ? "current #{sort_direction}" : nil
      direction = (table + "." + column == sort_column && sort_direction == "asc") ? "desc" : "asc"
      if column == "lurc_contact_id"
          css_class = ("LOWER(people.last_name)" == sort_column) ? "current #{sort_direction}" : nil
          direction = ("LOWER(people.last_name)" == sort_column && sort_direction == "asc" ? "desc" : "asc")
      end
      link_to title, {:sort => column, :direction => direction}, {:class => css_class}
    end
end
