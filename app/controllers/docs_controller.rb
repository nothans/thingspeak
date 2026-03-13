class DocsController < ApplicationController
  before_action :set_support_menu

  def index
    @timezones = {}

    ActiveSupport::TimeZone::MAPPING.each do |timezone|
      begin
        if @timezones[timezone[1]].present?
          @timezones[timezone[1]][:description] = @timezones[timezone[1]][:description] + ", #{timezone[0]}"
        else
          @timezones[timezone[1]] = {
            description: timezone[0],
            offset: Time.now.in_time_zone(timezone[0]).formatted_offset
          }
        end
      rescue ArgumentError
        next
      end
    end

    @timezones = @timezones.sort_by{ |identifier, hash| hash[:offset].to_i }.to_h
  end

  def errors; ; end
  def timecontrol; ; end
  def importer; ; end
  def charts; ; end
  def users; ; end

  def channels
    @channel_api_key = 'XXXXXXXXXXXXXXXX'
    @user_api_key = 'XXXXXXXXXXXXXXXX'

    if current_user && current_user.channels.any?
      @channel_api_key = current_user.channels.order('updated_at desc').first.write_api_key
      @user_api_key = current_user.api_key
    end
  end

  def thinghttp
    @thinghttp_api_key = 'XXXXXXXXXXXXXXXX'

    if current_user && current_user.thinghttps.any?
      @thinghttp_api_key = current_user.thinghttps.order('updated_at desc').first.api_key
    end
  end

  def talkback
    @talkback_id = 3
    @talkback_api_key = 'XXXXXXXXXXXXXXXX'

    if current_user && current_user.talkbacks.any?
      @talkback = current_user.talkbacks.order('updated_at desc').first
      @talkback_id = @talkback.id
      @talkback_api_key = @talkback.api_key
    end
  end

end
