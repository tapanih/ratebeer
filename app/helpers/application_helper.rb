module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Edit', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', item, data: { turbo_method: :delete, turbo_confirm: "Are you sure?" }, class: "btn btn-danger")

    if current_user.admin?
      raw("#{edit} #{del}")
    else
      raw(edit.to_s)
    end
  end

  def round(number)
    number_with_precision(number, precision: 1)
  end
end
