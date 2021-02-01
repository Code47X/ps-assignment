# frozen_string_literal: true

require_relative "../reciept"

describe Reciept do
  before(:each) do
    stub_const(
      "PRODUCTS",
      [
        { product: "book", tax_exempt: true, imported: false },
        { product: "music cd", tax_exempt: false, imported: false },
        { product: "chocolate bar", tax_exempt: true, imported: false },
        { product: "imported chocolate", tax_exempt: true, imported: true },
        { product: "imported music cd", tax_exempt: false, imported: true }
      ]
    )
  end

  describe "#initialize" do
    before(:each) do
      input = [
        { quantity: 1, product: "book", price: 8.00 },
        { quantity: 1, product: "music cd", price: 10.00 },
        { quantity: 1, product: "imported chocolate", price: 11.85 },
        { quantity: 1, product: "imported music cd", price: 10.00 }
      ]

      @reciept = Reciept.new(input)
    end

    it "calculates base sales tax for each item" do
      expect(@reciept.instance_variable_get(:@items)[0][:sales_tax]).to equal(0.0)
      expect(@reciept.instance_variable_get(:@items)[1][:sales_tax]).to equal(1.0)
    end

    it "calculates import sales tax for each item" do
      expect(@reciept.instance_variable_get(:@items)[2][:sales_tax]).to equal(0.6)
      expect(@reciept.instance_variable_get(:@items)[3][:sales_tax]).to equal(1.5)
    end
  end

  describe "#print" do
    before(:all) do
      input = [
        { quantity: 1, product: "book", price: 10.00 },
        { quantity: 1, product: "music cd", price: 10.00 },
        { quantity: 1, product: "chocolate bar", price: 10.00 }
      ]

      @reciept = Reciept.new(input)
    end

    it "prints the line items and price including tax" do
      expect { @reciept.print }.to output(/1, book, 10.00/).to_stdout
      expect { @reciept.print }.to output(/1, music cd, 11.00/).to_stdout
      expect { @reciept.print }.to output(/1, chocolate bar, 10.00/).to_stdout
    end

    it "prints the sales tax total" do
      expect { @reciept.print }.to output(/Sales Taxes: 1.00/).to_stdout
    end

    it "prints the total" do
      expect { @reciept.print }.to output(/Total: 31.00/).to_stdout
    end
  end
end
