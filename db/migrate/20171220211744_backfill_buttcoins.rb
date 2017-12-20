class BackfillButtcoins < ActiveRecord::Migration[5.1]
  def up
    User.find_each do |user|
      user.buttcoin_transaction(100, 'Initial Buttcoin Offering')

      user.shots.each do |shot|
        user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_shot], "Created Grab #{shot.hashid}")
      end

      user.memos.where.not(media_path: nil).each do |memo|
        memo.user.buttcoin_transaction(Buttcoin::AMOUNTS[:create_voice_memo], "Created Voice Memo #{memo.hashid}")
        memo.shot.user.buttcoin_transaction(Buttcoin::AMOUNTS[:receive_voice_memo], "Received Voice Memo #{memo.hashid}")
      end
    end
  end

  def down
    Buttcoin.delete_all
  end
end
