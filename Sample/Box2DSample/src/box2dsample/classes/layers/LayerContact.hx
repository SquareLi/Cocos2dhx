package box2dsample.classes.layers;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import box2D.dynamics.B2Body;
/**
 * ...
 * @author Ang Li(李昂)
 */
class LayerContact extends B2ContactListener
{
	
	var level : Level;
	public function new(l : Level) 
	{
		super();
		level = l;
	}
	
	override public function beginContact(contact:B2Contact):Void 
	{
		if ((contact.getFixtureA().getBody().getUserData() == 'hedgehog' && contact
				.getFixtureB().getBody().getUserData() == 'snail')
				|| (contact.getFixtureA().getBody().getUserData() == 'snail' && contact
						.getFixtureB().getBody().getUserData() == 'hedgehog')) {
			trace("contact");
			for (i in 0...level.snailsBodies.length) {
				// check if it is a snail-hedgehog collision (if
				// yes, remove the snail)
				if (level.snailsBodies[i] == contact.getFixtureA()
						.getBody()
						|| level.snailsBodies[i] == contact
								.getFixtureB().getBody()) {
					level.snailToRemove = i;
					break;
				}
			}

		}
	}
	
}