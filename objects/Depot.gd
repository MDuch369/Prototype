extends BasicUnit

@onready var build_box = $"Box2"
@onready var sprite =  $SupplyDepot
@onready var build_bar = $BuildingProgress
@onready var build_timer = $BuildTimer
var building_material = 0
var required_building_mat = 5000
var build_mode
var building
var active_transfers = []

#@onready var target = position
#var selected_unit = null

func _ready():
	super()
	build_bar.value = 0
	build_bar.max_value = required_building_mat
	add_to_group("non combat", true)
	add_to_group("friendly", true)
	add_to_group("supplier", true)
	icon = $WarehouseIcon

func _input(event):
	if event.is_action_pressed("LeftClick"):
		if build_mode:
			start_building()
#	follow_cursor = true
#	if event.is_action_released("RightClick"):
#		follow_cursor = false
#		
#func _process(delta):
#	if building:
#		build_bar.value = building_material

func _physics_process(delta):
	if build_mode:
		global_position = get_global_mouse_position()
	
func set_build_mode():
	build_mode = true
	sprite.visible = false
	box.visible = false
	build_bar.visible = false
	build_box.visible = true
	icon.visible = true

func start_building():
	build_mode = false
	building = true
	build_bar.visible = true
	build_timer.start(2)
	#build_box.visible = false
	
func finish_building():
	building = false
	sprite.visible = true
	box.visible = true
	build_bar.visible = false
	build_box.visible = false
	icon.visible = false

func _on_build_timer_timeout():
	building_material += 1000
	if building_material < 5000:
		build_bar.value = building_material
		build_timer.start(2)
	else:
		finish_building()
