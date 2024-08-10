require 'google/apis/youtube_v3'

class VideosController < ApplicationController
  before_action :authenticate_user!

  def new
    # Form for uploading video
  end

  def create
    client = Google::Apis::YoutubeV3::YouTubeService.new
    client.authorization = current_user.google_oauth_token

    video = Google::Apis::YoutubeV3::Video.new(
      snippet: {
        title: params[:title],
        description: params[:description]
      },
      status: {
        privacy_status: 'private'
      }
    )

    file = params[:video_file].tempfile

    begin
      client.insert_video('snippet,status', video, upload_source: file, content_type: 'video/*')
      flash[:notice] = 'Video uploaded successfully!'
    rescue Google::Apis::ClientError => e
      flash[:alert] = "An error occurred: #{e.message}"
    end

    redirect_to new_video_path
  end
end
