extends Node

const sqlite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")

var db
var data_path = "res://data/database.db"


func _ready():
	db = sqlite.new()
	db.path = data_path
	
func print_data():
	db.open_db()
	db.query("select * from owners")
	for i in range(0, db.query_result.size()):
		print(db.query_result[i])

func get_owners(id = null):
	var query = "select * from owners"
	if null != id:
		query += " where id = %s" % [str(id)]
	db.open_db()
	db.query(query)
	return db.query_result
	
func get_payers(id = null):
	var query = """
		select
		PAYERS.ID,
		OWNERS.NAME,
		OWNERS.GARAGE_NUMBER,
		PAYERS.IS_CLOSED
		from PAYERS 
		join OWNERS on OWNERS.ID = PAYERS.ID_OWNER"""
	if null != id:
		query += " where PAYERS.id_period = %s" % [str(id)]
	db.open_db()
	db.query(query)
	return db.query_result
	
func get_periods(id = null):
	var query = "select * from period"
	if null != id:
		query += "where id = %s" % [str(id)]
	db.open_db()
	db.query(query)
	return db.query_result
	
		
func insert_data(name:String):
	db.open_db()
	db.query("insert into players (name) values ('"+name+"')")
	
	
func save_image_to_db(texture:Texture):
	var image = texture.get_data()
	var data = process_image(image)
	db.open_db()
	if db.insert_row("images", data) == true:
		return get_images()[0]["ID"]
	else: 
		return null
	
func load_image_from_data(data):
	if data["DATA"]:
		var image = Image.new()
		image.create_from_data(
			data["WIDTH"], 
			data["HEIGHT"], 
			false, 
			data["FORMAT"], 
			data["DATA"])
		var texture = ImageTexture.new()
		texture.create_from_image(image, 0)
		return texture
	else: 
		return null


func get_images(id = null):
	var query = "select * from images"
	if null != id:
		query += " where id = %s" % [str(id)]
	query += " order by id desc"
	db.open_db()
	db.query(query)
	return db.query_result
	
func process_image(image: Image):
	var idata = {
	"WIDTH": image.get_width(),
	"HEIGHT": image.get_height(),
	"FORMAT": image.get_format()
	}
	var ibytes = image.get_data()
	idata["DATA"] = ibytes
	return idata
	
func set_image_to_owner(id_owner, id_image):
	db.open_db()
	var query = "update owners set id_counter_photo = %s where id = %s" % [str(id_image), str(id_owner)]
	db.query(query)
	
func get_owner_with_image(id_owner):
	db.open_db()
	var query = "select * from owners left join images on images.id = owners.id_counter_photo where owners.id = %s" % [str(id_owner)]
	db.query(query)
	return db.query_result[0]
	
func create_new_owner():
	db.open_db()
	var query = "insert into owners (NAME, GARAGE_NUMBER) values ('пусто', '0')"
	db.query(query)

func remove_owner(id):
	db.open_db()
	var query = "delete from owners where id = %s" % [str(id)]
	db.query(query)
	
func save_owner_data(id_owner, data):
	db.open_db()
	var query = "update owners set name = '%s', garage_number = '%s', id_counter_photo = %s where id = %s" % [str(data["NAME"]), str(data["GARAGE_NUMBER"]), str(data["ID_COUNTER_PHOTO"]), str(id_owner)]
	db.query(query)
	
func add_payers_to_period(id_period):
	db.open_db()
	var query = "insert into PAYERS (ID_PERIOD, ID_OWNER, IS_CLOSED) select '%s', OWNERS.ID, 'false' from OWNERS" % [str(id_period)]
	db.query(query)
	
	
func create_new_period(title, amount):
	db.open_db()
	var query = "insert into PERIOD (TITLE, AMOUNT) values ('%s', '%s') RETURNING id" % [str(title), int(amount)]
	db.query(query)
	return db.query_result[0]["ID"]
	
func get_payer_status(id_payer):
	db.open_db()
	var query = "SELECT IS_CLOSED FROM PAYERS WHERE PAYERS.ID = %s" % [str(id_payer)]
	db.query(query)
	return db.query_result[0]["IS_CLOSED"]
	
func set_payer_status(id_payer, status):
	db.open_db()
	var query = "UPDATE PAYERS SET IS_CLOSED = '%s' WHERE PAYERS.ID = %s" % [str(status) ,str(id_payer)]
	db.query(query)
	
func get_period_amount(id_period):
	db.open_db()
	var query = "SELECT AMOUNT FROM PERIOD WHERE PERIOD.ID = %s" % [str(id_period)]
	db.query(query)
	return db.query_result[0]["AMOUNT"]
	
