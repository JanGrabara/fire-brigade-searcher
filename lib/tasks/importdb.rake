def split_addres_to_street_and_number(addres)
  addres.sub!('ul.', '')
  addres.sub!('ul', '')

  if addres =~ /\d/
    splited_addres = addres.strip.split(' ')
    length = splited_addres.length

    last_nr_Index = length - 1 - splited_addres.reverse.index { |x| x =~ /\d/ }
    street = splited_addres[0...last_nr_Index].join(' ')
    nr = splited_addres[last_nr_Index...length].join('')
    [street, nr]
  else
    [addres, '']
  end
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
    street_nr = ''
    street = ''
    country = 'Poland'
    email = workbook.row(row)[headers['Służbowy adres e-mail']]
    city = workbook.row(row)[headers['Miejscowość']]
    postal_code = workbook.row(row)[headers['Kod pocztowy']]
    website = workbook.row(row)[headers['Służbowa strona WWW']]
    fax = workbook.row(row)[headers['FAX']]
    address = workbook.row(row)[headers['Adres']]
    unless address.to_s.empty?
      street, street_nr = split_addres_to_street_and_number address
    end

    i += 1
    @firestation = Firestation.new(email: email, city: city, country: country, postal_code: postal_code, website: website, fax: fax, street: street, street_nr: street_nr)

    if @firestation.save
      saved += 1
      print "saved row #{saved} \n"
    else
      print @firestation.errors.full_messages
    end
  end
  print "all doc #{i} saved correctly #{saved}"
end

namespace :importdb do
  desc 'import db from xls file'
  task import: :environment do
    path = 'Jednostki-organizacyjne-PSP2015.xls'
    workbook, headers = create_work_book_and_headers path
    save_Firestation(workbook, headers)
  end
end
