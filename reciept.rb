# frozen_string_literal: true

require "csv"

PRODUCTS = [
  { product: "book", tax_exempt: true, imported: false },
  { product: "music cd", tax_exempt: false, imported: false },
  { product: "chocolate bar", tax_exempt: true, imported: false },
  { product: "imported box of chocolates", tax_exempt: true, imported: true },
  { product: "imported bottle of perfume", tax_exempt: false, imported: true },
  { product: "bottle of perfume", tax_exempt: false, imported: false },
  { product: "packet of headache pills", tax_exempt: true, imported: false }
].freeze

# Reciept Class - calculates sales tax and prints reciept
class Reciept
  def initialize(items)
    @items = items
    @items.each { |i| calculate_sales_tax(i) }
  end

  def print
    print_line_items
    puts
    print_sales_tax
    print_total
  end

  private

  def print_line_items
    @items.each do |item|
      puts format("#{item[:quantity]}, #{item[:product]}, %<total>0.2f", total: item[:total])
    end
  end

  def print_sales_tax
    puts format("Sales Taxes: %<total>0.2f", total: @items.map { |i| i[:sales_tax] }.sum)
  end

  def print_total
    puts format("Total: %<total>0.2f", total: @items.map { |i| i[:total] }.sum)
  end

  def product_tax_rate(product_name)
    product = PRODUCTS.find { |p| p[:product] == product_name }

    tax_rate = 0
    tax_rate += product[:tax_exempt] ? 0 : 10
    tax_rate += product[:imported] ? 5 : 0

    tax_rate
  end

  def calculate_sales_tax(item)
    tax_rate = product_tax_rate(item[:product])
    amount = item[:price] * item[:quantity]

    sales_tax = ((tax_rate * amount / 100) * 20).ceil.round / 20.00

    item[:sales_tax] = sales_tax.truncate(2)
    item[:total] = item[:price] + item[:sales_tax]
  end
end

# To run with the provided inputs

# input_1 = CSV.parse(
#   File.read("input_1.csv"),
#   headers: true,
#   header_converters: :symbol,
#   converters: :numeric,
#   col_sep: ", "
# )

# input_2 = CSV.parse(
#   File.read("input_2.csv"),
#   headers: true,
#   header_converters: :symbol,
#   converters: :numeric,
#   col_sep: ", "
# )

# input_3 = CSV.parse(
#   File.read("input_3.csv"),
#   headers: true,
#   header_converters: :symbol,
#   converters: :numeric,
#   col_sep: ", "
# )

# r = Reciept.new(input_1)
# r = Reciept.new(input_2)
# r = Reciept.new(input_3)

# r.print
