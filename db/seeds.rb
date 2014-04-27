# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Program.create(title: '僕らはみんな河合荘', from: Date.new(2014, 4, 3))
Program.create(title: '悪魔のリドル', from: Date.new(2014, 4, 3))

Character.create(name: '宇佐和成', actor: '井口祐一', program_id: 1)
Character.create(name: '河合律', actor: '花澤香菜', program_id: 1)
Character.create(name: '城崎', actor: '四宮豪', program_id: 1)
Character.create(name: '錦野麻弓', actor: '佐藤利奈', program_id: 1)
Character.create(name: '渡辺彩花', actor: '金元寿子', program_id: 1)
Character.create(name: '河合住子', actor: '小林沙苗', program_id: 1)
