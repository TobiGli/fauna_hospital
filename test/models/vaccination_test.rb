require "test_helper"

class VaccinationTest < ActiveSupport::TestCase
  test "calculates the next annual dose when it is omitted" do
    vaccination = Vaccination.new(
      patient: patients(:one),
      vaccine_name: "Rabia",
      applied_at: Date.new(2026, 11, 11)
    )

    assert vaccination.valid?
    assert_equal Date.new(2027, 11, 11), vaccination.next_due_at
  end

  test "rejects an applied date in the future" do
    vaccination = Vaccination.new(
      patient: patients(:one),
      vaccine_name: "Rabia",
      applied_at: Date.current + 1.day
    )

    assert_not vaccination.valid?
    assert_includes vaccination.errors[:applied_at], "can't be in the future"
  end

  test "rejects a due date before the applied date" do
    vaccination = Vaccination.new(
      patient: patients(:one),
      vaccine_name: "Rabia",
      applied_at: Date.current,
      next_due_at: Date.current - 1.day
    )

    assert_not vaccination.valid?
    assert_includes vaccination.errors[:next_due_at], "can't be before the applied date"
  end
end
