# This file should contain all the record creation needed to seed the database
# with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if (User.with_role :super).blank?
  user = User.create! email: 'super@super.com', password: 'super',
                      password_confirmation: 'super', locale: 'ru'
  user.add_role :super
end
