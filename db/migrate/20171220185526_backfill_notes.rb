class BackfillNotes < ActiveRecord::Migration[5.1]
  def up
    Memo.find_each do |memo|
      puts "[:voice_memo] memo: #{memo.id} user: #{memo.shot.user.id} actor: #{memo.user.id} cross_ref: #{memo.id}"
      memo.shot.user.notes.create(variant: :voice_memo, actor: memo.user, cross_ref: memo, meta: { summary: memo.message })
    end

    Chomment.where("message like ?", "%@%").each do |chomment|
      chomment.at_replied_users.each do |replied_user|
        puts "[:at_reply] chomment: #{chomment.id} user: #{replied_user.id} actor: #{chomment.user.id} cross_ref: #{chomment.id}"
      end
      chomment.notify_at_replied_users
    end
  end

  def down
    Note.delete_all
  end
end
