package rblx;

import rblx.instances.*;
import rblx.services.*;
import rblx.enums.*;

@:forward
@:forward.new
@:forwardStatics
@:native("PhysicalProperties")
extern abstract PhysicalProperties(PhysicalPropertiesData) {}

@:native("PhysicalProperties")
private extern class PhysicalPropertiesData
{
	/**
	 * Returns a PhysicalProperties with the default properties for the given material.
	 */
	@:native("new")
	public static extern function fromMaterial(material:Material):PhysicalProperties;

	/**
	 * Creates a PhysicalProperties container with the specified density, friction, elasticity, weight of friction, and weight of elasticity.
	 */
	public extern function new(density:Float, friction:Float, elasticity:Float, frictionWeight:Float, elasticityWeight:Float);

	/**
	 * A value between 0 and 1 denoting how absorbent the material is to AudioEmitters.
	 */
	@:native("AcousticAbsorption")
	public extern var acousticAbsorption:Float;

	/**
	 * The mass per unit volume of the part.
	 */
	@:native("Density")
	public extern var density:Float;

	/**
	 * The deceleration of the part when rubbing against another part.
	 */
	@:native("Friction")
	public extern var friction:Float;

	/**
	 * The amount of energy retained when colliding with another part.
	 */
	@:native("Elasticity")
	public extern var elasticity:Float;

	/**
	 * The importance of the part's Friction property when calculating the friction with the colliding part.
	 */
	@:native("FrictionWeight")
	public extern var frictionWeight:Float;

	/**
	 * The importance of the part's Elasticity property when calculating the elasticity with the colliding part.
	 */
	@:native("ElasticityWeight")
	public extern var elasticityWeight:Float;
}
