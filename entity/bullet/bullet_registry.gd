extends Node

enum BULLET_TYPE {
	EMPTY,
	BULLET,
	SLUG,
	SEMISLUG
}

@onready var REGISTRY = {
	BULLET_TYPE.EMPTY: null,
	BULLET_TYPE.BULLET: preload('res://entity/bullet/bullet.tscn'),
	BULLET_TYPE.SLUG: preload('res://entity/bullet/slug.tscn'),
	BULLET_TYPE.SEMISLUG: preload('res://entity/bullet/semislug.tscn')
}
