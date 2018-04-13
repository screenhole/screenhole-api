require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  test 'note can be broadcasted #can_broadcast?' do
    note = notes(:two)
    note.variant = :chomment
    note.save

    assert note.can_broadcast?

    note.variant = :at_reply
    note.save

    assert note.can_broadcast?
  end

  test 'note will not be broadcasted #can_broadcast?' do
    note = notes(:two)

    note.variant = :voice_memo
    note.save

    assert_not note.can_broadcast?
  end
end
