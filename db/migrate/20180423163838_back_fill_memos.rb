class BackFillMemos < ActiveRecord::Migration[5.1]
  def change
    to_delete = []

    Memo.find_each do |memo|
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
          }
        )
      end
    end

    Note.where(id: to_delete).destroy_all
  end
end
