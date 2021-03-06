require 'order'

describe Order do
  let(:dish) { double("dish") }
  let(:menu) { double("menu") }
  let(:order) { double("order") }
  let(:order_array) { [dish, dish] }
  let(:invoice) { instance_double("invoice") }
  subject { described_class.new(menu, invoice) }
  before(:each) do
    allow(dish).to receive_messages(downcase: dish, to_sym: dish, name: dish, select: dish, dishes: dish, values: dish, each: dish)
    allow(menu).to receive(:select).with(dish) { dish }
    allow(menu).to receive_messages(dishes: dish, values: dish, each: dish)
    allow(invoice).to receive(:calculate).with(order) { 6 }
  end

  it { is_expected.to be_instance_of(Order) }

  it { is_expected.to respond_to(:view_menu) }

  it { is_expected.to respond_to(:select) }

  it { is_expected.to respond_to(:place_order) }

  describe '#view_menu' do
    it "displays the menu" do
      printed_menu = "Pizza: £6.50\nSpaghetti: £5.75\nSalad: £5.25"
      allow(menu).to receive(:view) { printed_menu }
      expect(subject.view_menu).to eq printed_menu
    end
  end

  describe '#select' do
    it "saves the selected dish to the order" do
      expect { subject.select(dish, 1) }.to change { subject.order }
    end

    it "saves the correct quantity of dishes to the order" do
      expect { subject.select(dish, 2) }.to change { subject.order }
    end
  end

  describe '#summarise' do
    it "creates array of dish names" do
      allow(order_array).to receive(:count)
      expect { subject.summarise(order_array) }.to change { subject.order_summary }
    end
  end

  it "calculates_total" do
    subject.calculate_total(order)
    expect(subject.total).to eq 6
  end

  describe '#prints_order_summary' do
    it "adds info to order_output" do
      allow(dish).to receive(:[])
      expect { subject.prints_order_summary(order_array) }.to change { subject.order_output }
    end
  end

  describe '#place_order' do
    it "returns list of dishes to stdout" do
      allow(subject).to receive(:calculate_total) { 6 }
      allow(invoice).to receive(:send_text)
      expect { subject.place_order }.to output.to_stdout
    end
  end
end
