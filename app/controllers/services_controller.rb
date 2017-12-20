class ServicesController < ApplicationController
  def voice_memo
    # load by calling_code if it's present
    if params.has_key? :calling_code
      memo = Memo.find_by(calling_code: params[:calling_code])
    elsif params.has_key? :call_sid
      memo = Memo.find_by(call_sid: params[:call_sid])
    end

    unless memo.present?
      render status: 400, json: {
        status: 400,
        detail: "Couldn't find Memo"
      } and return
    end

    unless memo.voice?
      render status: 400, json: {
        status: 400,
        detail: "Memo isn't voice"
      } and return
    end

    if params.has_key? :call_sid
      if memo.call_sid.blank?
        # save call_sid
        memo.call_sid = params[:call_sid]
      elsif memo.call_sid != params[:call_sid]
        # don't allow re-calls (changing call_sid)
        render status: 400, json: {
          status: 400,
          detail: "Can't reuse calling code"
        } and return
      end
    end

    # transload recording
    if params.has_key? :recording_url
      # TODO: wait for copy to update model

      memo.media_path = "#{memo.user.hashid}/voice_memo/#{Time.now.to_i}.mp3"
      TransloadRemoteFile.new("#{params[:recording_url]}.mp3").upload_to_s3(memo.media_path, 'audio/mpeg')

      # TODO: delete from Twilio
      memo.pending = false
    end

    # save transcription_text
    if params.has_key? :transcription_text
      memo.message = params[:transcription_text]
      memo.user.chomments.create(
        variant: :voice_memo,
        cross_ref: memo.shot,
        message: memo.message,
      )

      # send notification to shot user that caller left a voice memo
      memo.shot.user.notes.create(variant: :voice_memo, actor: memo.user, cross_ref: memo, meta: { summary: memo.message })
    end

    if memo.save
      render json: memo
    else
      respond_with_errors(memo)
    end
  end
end
