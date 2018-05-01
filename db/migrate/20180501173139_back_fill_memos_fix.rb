class BackFillMemosFix < ActiveRecord::Migration[5.1]
  def change
    to_delete = []

    Note.record_timestamps = false

    Memo.where('Date(created_at) < ?', '2018-04-24').find_each do |memo|
      grab = memo.grab

      Note.where(cross_ref: memo).find_each do |note|
        to_delete << note.id

        buttcoin_earned = memo.message ? Buttcoin::AMOUNTS[:receive_chomment_memo_per_char] * memo.message.length : 0

        memo.grab.user.notes.create!(
          variant: memo.variant,
          user: memo.grab.user,
          actor: memo.user,
          cross_ref: memo,
          meta: {
            grab_id: memo.grab.hashid,
            summary: memo.message,
            buttcoin_earned: buttcoin_earned
          },
          created_at: grab.created_at,
          updated_at: grab.created_at
        )
      end
    end

    Note.record_timestamps = true

    Note.where(id: to_delete).destroy_all
  end
end
