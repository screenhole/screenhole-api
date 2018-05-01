class BackFillMemosFix < ActiveRecord::Migration[5.1]
  def change
    to_delete = []

    Note.record_timestamps = false

    Memo.where('Date(created_at) < ?', '2018-04-24').find_each do |memo|
      next if memo.variant == 'sticker'

      grab = memo.grab
      buttcoin_earned = memo.message ? Buttcoin::AMOUNTS[:receive_chomment_memo_per_char] * memo.message.length : 0

      if Note.exists?(cross_ref: memo)
        to_delete << Note.where(cross_ref: memo).pluck(:id)
      end

      grab.user.notes.create!(
        variant: memo.variant,
        user: grab.user,
        actor: memo.user,
        cross_ref: memo,
        meta: {
          grab_id: grab.hashid,
          summary: memo.message,
          buttcoin_earned: buttcoin_earned
        },
        created_at: grab.created_at,
        updated_at: grab.created_at
      )
    end

    Note.record_timestamps = true

    Note.where(id: to_delete.flatten).destroy_all
  end
end
