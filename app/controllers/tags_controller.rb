class TagsController < ApplicationController
  def index

    render 'show' and return if params[:channel_id].nil?
    
    channel = Channel.find(params[:channel_id])
    if current_user && channel.nil?
      tag = Tag.includes(:channels).where('channels.public_flag = true OR channels.user_id = ?', current_user.id).references(:channels).find_by(name: params[:id])
    else
      channels = []
      channel.tags.each do |tag|
        channels << tag.channel_ids
      end
      
      channels = channels.flatten.uniq

    end
    redirect_to public_channels_path(:channel_ids => channels)
  end

  def create
    redirect_to tag_path(params[:tag][:name])
  end

  def show
    # if user is logged in, search their channels also
    if current_user
      tag = Tag.includes(:channels).where('channels.public_flag = true OR channels.user_id = ?', current_user.id).references(:channels).find_by(name: params[:id])
      # else only search public channels
    else
      tag = Tag.includes(:channels).where('channels.public_flag = true').references(:channels).find_by(name: params[:id])
    end

    @results = tag.channels if tag
  end

end
