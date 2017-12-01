class ServicesController < ApplicationController
  def voice_memo
    if params.has_key? :calling_code
      memo = Memo.find_by(calling_code: params[:calling_code])
    elsif params.has_key? :call_sid
      memo = Memo.find_by(call_sid: params[:call_sid])
    end

    unless memo.present?
      render json: {
        status: 400,
        detail: "Couldn't find Memo"
      } and return
    end

    unless memo.voice?
      render json: {
        status: 400,
        detail: "Memo isn't voice"
      } and return
    end

    if (params.has_key? :recording_url)
      # TODO: transload to S3
      # TODO: delete from Twilio
      memo.media_path = params[:recording_url]
      memo.pending = false
    end

    if (params.has_key? :transcription_text)
      memo.message = params[:transcription_text]
    end

    if memo.save
      render json: memo
    else
      respond_with_errors(memo)
    end
  end
end
