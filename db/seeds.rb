# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Program.create(title: '僕らはみんな河合荘', from: Date.new(2014, 4, 3))
Program.create(title: '悪魔のリドル', from: Date.new(2014, 4, 3))

Actor.create(name: '井口祐一', birth: Date.new(0,2,22))
Actor.create(name: '花澤香菜', birth: Date.new(1989,2,25))
Actor.create(name: '四宮豪', birth: Date.new(1975,6,6))
Actor.create(name: '佐藤利奈', birth: Date.new(1981,5,2))
Actor.create(name: '金元寿子', birth: Date.new(1987,12,16))
Actor.create(name: '小林沙苗', birth: Date.new(1980,1,26))

Character.create(name: '宇佐和成', actor_id: 1, program_id: 1)
Character.create(name: '河合律',   actor_id: 2, program_id: 1)
Character.create(name: '城崎',     actor_id: 3,  program_id: 1)
Character.create(name: '錦野麻弓', actor_id: 4, program_id: 1)
Character.create(name: '渡辺彩花', actor_id: 5, program_id: 1)
Character.create(name: '河合住子', actor_id: 6, program_id: 1)

Staff.create(name: '宮原るり',   role: '原作')
Staff.create(name: '宮繁之',     role: '監督')
Staff.create(name: '古怒田健志', role: '脚本')
Staff.create(name: '栗田新一',   role: 'キャラクターデザイン')

ProgramStaff.create(staff_id: 1, program_id: 1, role: '原作')
ProgramStaff.create(staff_id: 2, program_id: 1, role: '監督')
ProgramStaff.create(staff_id: 3, program_id: 1, role: '脚本')
ProgramStaff.create(staff_id: 4, program_id: 1, role: 'キャラクターデザイン')


