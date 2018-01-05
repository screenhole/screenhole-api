class RenameShotPolyRefs < ActiveRecord::Migration[5.1]
  def up
    Chomment.where(cross_ref_type: "Shot").each do |x|
      x.update_attribute(:cross_ref_type, "Grab")
    end

    Note.where(cross_ref_type: "Shot").each do |x|
      x.update_attribute(:cross_ref_type, "Grab")
    end
  end

  def down
    Chomment.where(cross_ref_type: "Grab").each do |x|
      x.update_attribute(:cross_ref_type, "Shot")
    end

    Note.where(cross_ref_type: "Grab").each do |x|
      x.update_attribute(:cross_ref_type, "Shot")
    end
  end
end
