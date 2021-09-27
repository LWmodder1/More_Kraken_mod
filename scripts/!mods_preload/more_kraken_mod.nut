::mods_registerMod("mod_more_krakens", 1.0, "Spawning more Krakens");
::mods_queue("mod_more_krakens", null, function()
{
	::mods_hookNewObject("factions/actions/send_beast_roamers_action", function ( obj )
	{
		local beast = function ( _action, _nearTile = null )
		{
			// i comment this 'if check' so kraken can spawn even when you haven't killed the one in legendary location, remove it if you want it keep this spawn condition
			/*if (!this.World.Flags.get("IsKrakenDefeated"))
			{
				return false;
			}*/

			local disallowedTerrain = [];
			
			// i add this so it won't be messy with a tons of i == || i == || i === ....
			local validTerrain = [
				this.Const.World.TerrainType.Swamp,
				this.Const.World.TerrainType.Ocean,
				this.Const.World.TerrainType.Shore,
				this.Const.World.TerrainType.Oasis,
			];

			for( local i = 0; i < this.Const.World.TerrainType.COUNT; i = i )
			{
				if (validTerrain.find(i) != null)
				{
				}
				else
				{
					disallowedTerrain.push(i);
				}

				i = ++i;
			}

			local tile = _action.getTileToSpawnLocation(10, disallowedTerrain, 25, 1000, 1000, 3, 0, _nearTile);

			if (tile == null)
			{
				return false;
			}

			if (_action.getDistanceToNextAlly(tile) <= distanceToNextAlly)
			{
				return false;
			}

			local distanceToNextSettlement = _action.getDistanceToSettlements(tile);

			if (this.LegendsMod.Configs().LegendLocationScalingEnabled())
			{
				distanceToNextSettlement = distanceToNextSettlement * 2;
			}

			local party = _action.getFaction().spawnEntity(tile, "Kraken", false, this.Const.World.Spawn.Kraken, 1000);
			party.getSprite("banner").setBrush("banner_beasts_01");
			party.setDescription("A tentacled horror from another age.");
			party.setFootprintType(this.Const.World.FootprintsType.Kraken);
			party.setSlowerAtNight(true);
			party.setUsingGlobalVision(false);
			party.setLooting(false);

			// set the new base speed only 20% compare the usual
			party.setMovementSpeed(this.Math.floor(party.getBaseMovementSpeed() * 0.2));

			local roam = this.new("scripts/ai/world/orders/roam_order");
			roam.setNoTerrainAvailable();
			
			// set terrain type so spawned kraken don't roam outside of intended terrain
			roam.setTerrain(this.Const.World.TerrainType.Swamp, true);
			roam.setTerrain(this.Const.World.TerrainType.Ocean, true);
			roam.setTerrain(this.Const.World.TerrainType.Shore, true);
			roam.setTerrain(this.Const.World.TerrainType.Oasis, true);
			party.getController().addOrder(roam);
			return true;
		};
		
		// I push this function 3 times so there is more chance for fucntion to be picked
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
		obj.m.Options.push(beast);
	});
})

