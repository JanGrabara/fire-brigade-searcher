def split_addres_to_street_and_number(addres)
  addres.sub!('ul.', '')
  addres.sub!('ul', '')
  splited_addres = addres.strip.split(' ')
  length = splited_addres.length

  last_nr_Index = length - 1 - splited_addres.reverse.index { |x| x =~ /\d/ }
  street = splited_addres[0...last_nr_Index].join(' ')
  nr = splited_addres[last_nr_Index...length].join('')
  [street, nr]
end

def create_work_book_and_headers(path)
  require 'roo'
  workbook = Roo::Excel.new(path)

  workbook.default_sheet = workbook.sheets[0]

  headers = {}
  workbook.row(1).each_with_index do |header, i|
    headers[header] = i
  end

  [workbook, headers]
end

def save_Firestation(workbook, headers)
  i = 0
  saved = 0
  ((workbook.first_row + 1)..workbook.last_row).each do |row|
    email = workbook.row(row)[headers['Służbowy adres e-mail']]
    city = workbook.row(row)[headers['Miejscowość']]
    country = 'Poland'
    postal_code = workbook.row(row)[headers['Kod pocztowy']]
    website = workbook.row(row)[headers['Służbowa strona WWW']]
    fax = workbook.row(row)[headers['FAX']]
    street, street_nr = split_addres_to_street_and_number workbook.row(row)[headers['Adres']]
    i += 1
    @firestation = Firestation.new(email: email, city: city, country: country, postal_code: postal_code, website: website, fax: fax, street: street, street_nr: street_nr)

    saved += 1 if @firestation.save
  end
  print "all doc #{i} saved correctly #{saved}"
end

namespace :importdb do
  desc 'import db from xls file'
  task import: :environment do
    path = 'Jednostki-organizacyjne-PSP2015.xls'

    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    workbook, headers = create_work_book_and_headers path
    save_Firestation(workbook, headers)
  end

  task printfs: :environment do
    @firestation = Firestation.near("Wroc\xC5\x82aw", 5, units: :km)

    print 'Start'
    @firestation.each do |x|
      print "x #{x.city}:#{x.country}:#{x.postal_code}:#{x.street}: #{x.street_nr} #{x.longitude} #{x.latitude}\n"
    end
  end
end
