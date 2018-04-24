require 'test_helper'

class MemoTest < ActiveSupport::TestCase
  test 'it can be duplicated' do
    memo = memos(:one)

    new_meta = memo.meta || {}
    new_meta['grab_id'] = memo.grab.hashid

    assert Memo.create!(variant: memo.variant,
        media_path: memo.media_path,
        message: memo.message,
        created_at: memo.created_at,
        user_id: memo.user_id,
        grab_id: memo.grab_id,
        pending: memo.pending,
        calling_code: memo.calling_code,
        call_sid: memo.call_sid,
        meta: new_meta)
  end
end
