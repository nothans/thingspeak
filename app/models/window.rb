# == Schema Information
#
# Table name: windows
#
#  id           :integer          not null, primary key
#  channel_id   :integer
#  position     :integer
#  created_at   :datetime
#  updated_at   :datetime
#  html         :text
#  col          :integer
#  title        :string(255)
#  window_type  :string(255)
#  name         :string(255)
#  private_flag :boolean          default(FALSE)
#  show_flag    :boolean          default(TRUE)
#  content_id   :integer
#  options      :text
#

# content_id refers to plugin_id, field_number, etc depending on the window type
# valid values for window_type: status, location, chart, plugin, video
class Window < ApplicationRecord
  belongs_to :channel

  self.include_root_in_json = true

  def private?
    return private_flag
  end

  # set the title for display to user; don't save after calling this method
  def set_title_for_display!
    if window_type == "chart"
      self.title = I18n.t(title, field_number: content_id)
    # else set title for other window types, for example: I18n.t('window_map') = 'Channel Location'
    else
      self.title = I18n.t(title)
    end
  end

  # set the html for display to user; don't save after calling this method
  def set_html_for_display!
    if window_type == "chart"
      html_options = options || ''
      # replace '::OPTIONS::' if present
      self.html['::OPTIONS::'] = html_options if html.present? && html.index("::OPTIONS::").present?
    end
  end

end

