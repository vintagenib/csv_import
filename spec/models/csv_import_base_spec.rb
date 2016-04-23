RSpec.describe CSVImporter do

  let :importer do
    CSVImporter.new(
      path: File.expand_path('../../files/customer-list.csv', __FILE__),
      keymap: {},
      object_class: Customer,
      defaults: {
        site_id: 56
      }
    )
  end
  let :keymap do
    {
      customer_id:        nil,
      customer_name:      :sold_to_company,
      contact:            :contact,
      telephone_1:        :phone,
      email:              :email,
      bill_to_address_1:  :sold_to_address1,
      bill_to_address_2:  :sold_to_address2,
      bill_to_city:       :sold_to_city,
      bill_to_state:      :sold_to_state,
      bill_to_zip:        :sold_to_zip,
      ship_to_address_1:  :ship_to_address1,
      fax:                :fax
    }
  end

  describe :importer do

    it "accepts four named arguments--:path, :keymap, :object_class, :defaults" do

      expect(importer.keymap).to be_an_instance_of(Hash)
      expect(importer.object_class).to equal Customer
      expect(importer.defaults).to be_an_instance_of(Hash)
      expect(importer.defaults[:site_id]).to equal 56

    end


    it "reads csv file using a header row with with keys turned to symbols" do

      expected_headers = [:customer_id, :customer_name, :contact, :telephone_1,
        :email, :bill_to_address_1, :bill_to_address_2, :bill_to_city,
        :bill_to_state, :bill_to_zip, :ship_to_address_1, :fax]

      expect(importer.parsed_csv).to be_an_instance_of(CSV::Table)
      expect(importer.parsed_csv.headers).to match(expected_headers)

    end


    it "checks to make sure keymap matches header keys" do


      expect(importer.keys_covered?).to be(false)

      importer.keymap = keymap

      expect(importer.keys_covered?).to be(true)

    end


    it "parses the attributes for the object from a row" do
      importer.keymap = keymap
      row = importer.parsed_csv.first

      attributes = importer.parsed_attributes_from(row: row)

      expect(row[:customer_name]).to match("1st Express, Inc.***")

      expect(attributes).to be_an_instance_of(Hash)
      expect(attributes).to match({
        sold_to_company:  "1st Express, Inc.***",
        contact:          "Patrick Southward",
        phone:            "419-476-6881",
        email:            "pat@1stexpressinc.com",
        sold_to_address1: "Atten:  Accounts Payable",
        sold_to_address2: "227 Matzinger Road",
        sold_to_city:     "Toledo",
        sold_to_state:    "OH",
        sold_to_zip:      "43612",
        ship_to_address1: nil,
        fax:              nil
      })
    end


    it "mixes in the default attributes that were provided" do
      importer.keymap = keymap
      row = importer.parsed_csv.first
      attributes = importer.attributes_for(row: row)
      expect(attributes[:site_id]).to eq(56)
    end


    it "creates a customer from a row" do
      importer.keymap = keymap
      row = importer.parsed_csv.first
      importer.delayed = false

      new_customer = importer.create_object_from(row: row)

      expect(new_customer.new_record?).to   be(false)
      expect(new_customer).to               be_an_instance_of(Customer)

      expect(new_customer.contact).to       eq("Patrick Southward")
      expect(new_customer.email).to         eq("pat@1stexpressinc.com")
    end


    it "creates delayed jobs for creating all the customers" do
      importer.keymap = keymap
      importer.process_file!
      expect(Delayed::Job.count).to  eq(100)
      Delayed::Job.delete_all
    end


    it "wont process the file if the keymap doesn't cover all the keys" do
      expect(importer.process_file!).to be(false)
      expect(Delayed::Job.count).to eq(0)
    end

  end
end
