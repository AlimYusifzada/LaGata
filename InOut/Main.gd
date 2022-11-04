extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var addnew=preload("res://AddNewPerson.tscn")
onready var remove=preload("res://RemovePerson.tscn")
onready var person=preload("res://Person.tscn")	

var data="user://data"
var panelstyle=StyleBoxFlat.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var root=get_tree().get_root()
	var addnewinst=addnew.instance()
	VisualServer.set_default_clear_color(Color.black)
	panelstyle.bg_color=Color.darkgreen
	addnewinst.position.x=230
	addnewinst.position.y=150
	root.add_child(addnewinst)
	readList()
	pass

func updatelist():
	$In.clear()
	$Out.clear()
	$Visitors.clear()
	var persons=get_children()
	for p in persons:
		var PersonName=p.get("PersonName")
		var Status=p.get("Status")
		var Visitor=p.get("Visitor")
		var PTime=p.get("PTime")
		if PersonName==null or Status==null or Visitor==null or PTime==null:
			continue
		if Visitor:
			$Visitors.add_item(PersonName+" - "+PTime)
			continue
		if Status:
			$In.add_item(PersonName+" - "+PTime)
		else:
			$Out.add_item(PersonName+" - "+PTime)
	$In.update()
	$Out.update()
	$Visitors.update()
	pass

func gettexture(path="res://ABBLogoScaled.png"):
	var fpath=File.new()
	if !fpath.file_exists(path):
		return null
	var img=Image.new()
	img.load(path)
	var tex=ImageTexture.new()
	tex.create_from_image(img)
	return tex

func readList():
	var file=File.new()
	var test=[]
	if file.file_exists(data):
		file.open(data,File.READ)
		test=parse_json(file.get_line())
		file.close()
		for p in test:
			var personinst=person.instance()
			personinst.PersonName=p[0]
			personinst.Status=p[1]
			personinst.PTime=p[2]
			personinst.Visitor=p[3]
			add_child(personinst)
			pass
	else:
		print("sorry, no data")
	updatelist()
	pass #read people from file
	
func writeList():
	var persons=get_children()
	var test=[]
	for p in persons:
		if p.get("PersonName")!=null and p.get("Status")!=null and p.get("PTime")!=null and p.get("Visitor")!=null:
			test.append([p.get("PersonName"),p.get("Status"),p.get("PTime"),p.get("Visitor")])
	var file=File.new()
	file.open(data,File.WRITE)
	file.store_line(to_json(test))
	file.close()
	pass #write people to file	


func _on_ExitBtn_pressed():
	writeList()
	get_tree().quit(0)
	pass # Replace with function body.
	
func _on_In_item_selected(index):
	var selName=$In.get_item_text(index)
	for p in get_children():
		var name=p.get("PersonName")
		if name==null: continue
		if p.get("PersonName") in selName:
			get_node(p.name).setout()
			break
	updatelist()

func _on_Out_item_selected(index):
	var selName=$Out.get_item_text(index)
	for p in get_children():
		var name=p.get("PersonName")
		if name==null: continue
		if name in selName:
			get_node(p.name).setin()
			break
	updatelist()

func _on_Add_pressed(): #call interface
	var root=get_tree().get_root()
	var addnewinst=addnew.instance()
	addnewinst.position.x=10
	addnewinst.position.y=10
	root.add_child(addnewinst)
	pass # Replace with function body.


func _on_Remove_pressed():
	var root=get_tree().get_root()
	var removeinst=remove.instance()
	removeinst.position.x=10
	removeinst.position.y=10
	root.add_child(removeinst)
	pass # Replace with function body.

func AddNewPerson(Name,visitor):
	var personinst=person.instance()
	var td=OS.get_time()
	var minstr=str(td.get("minute"))
	if minstr.length()<2:
		minstr="0"+minstr
	var PTime=str(td.get("hour"))+":"+minstr	
	personinst.PersonName=Name #+tdtxt
	personinst.Status=false
	personinst.Visitor=visitor
	personinst.PTime=PTime
	add_child(personinst)
	updatelist()
	pass

func RemovePerson(Name):
	var persons=get_children()
	for p in persons:
		var tempn=p.get("PersonName")
		if tempn==null:continue
		if Name in tempn:
			p.queue_free()
	updatelist()
	pass


func _on_Visitors_item_selected(index):
	var pername=$Visitors.get_item_text(index)
	for p in get_children():
		var name=p.get("PersonName")
		if name==null: continue
		if name in pername:
			p.queue_free()
	updatelist()
	pass # Replace with function body.
	
func delete_all():
	for p in get_children():
		if p.get("PTime")!=null:
			p.queue_free()
	updatelist()
	pass
