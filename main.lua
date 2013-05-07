--~ Programmer:  Joe Kowalsky
--~ Program#:    olab9 part4
--~ Due date:    4/19/12 @ 11:59pm
--~ Instructor:  Dr. Al Cripps, CSCI 3210
--~ Added Features:
		-- Faster shooting
		-- Prompt for choice of enemies
		-- End Game message for win or loss, with borrowed graphic


function love.load()
	hero = {} -- new table for the hero
	hero.x = 300    -- x,y coordinates of the hero
	hero.y = 450
	hero.width = 30
    hero.height = 15
    hero.speed = 150
	hero.shots = {} -- holds our fired shots

	max_enemies = 0
	enemies = {}

	-- load background
	bg = love.graphics.newImage("bg.png")
	endLogo = love.graphics.newImage("last starfighter patch large.png")
end

function love.update(dt)
	-- keep hero from leaving screen
	if hero.x>800 then
		hero.x=800-hero.x
	elseif hero.x<0 then
		hero.x=hero.x+800
	end

	if love.keyboard.isDown("left") then
		hero.x = hero.x - hero.speed*dt
	elseif love.keyboard.isDown("right") then
		hero.x = hero.x + hero.speed*dt
	end

	for i,v in ipairs(enemies) do
		-- let them fall down slowly
		v.y = v.y + dt*50

		-- check for collision with ground
		if v.y > 465 then
			endGame("lose")-- you loose!!!
		end

	end

	local remEnemy = {}
    local remShot = {}

    -- update those shots
    for i,v in ipairs(hero.shots) do

        -- move them up up up
        v.y = v.y - dt * 100

        -- mark shots that are not visible for removal
        if v.y < 0 then
            table.insert(remShot, i)
        end

        -- check for collision with enemies
        for ii,vv in ipairs(enemies) do
            if CheckCollision(v.x,v.y,2,5,vv.x,vv.y,vv.width,vv.height) then
                -- mark that enemy for removal
                table.insert(remEnemy, ii)
                -- mark the shot to be removed
                table.insert(remShot, i)

            end
        end
    end

    -- remove the marked enemies
    for i,v in ipairs(remEnemy) do
        table.remove(enemies, v)
		if #enemies == 0 then
			endGame('win')
		end
    end

    for i,v in ipairs(remShot) do
        table.remove(hero.shots, v)
    end


end

function love.draw()
	-- draw background
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(bg)

	-- let's draw some ground
	love.graphics.setColor(0,255,0,255)
	love.graphics.rectangle("fill", 0, 465, 800, 150)

	-- let's draw our hero
	love.graphics.setColor(255,255,0,255)
	love.graphics.rectangle("fill", hero.x,hero.y, 30, 15)

	love.graphics.print( "Greetings Starfighter", 270, 0, 0, 2, 2)
	love.graphics.print( "Choose number of enemies(1-7)", 200, 20, 0, 2, 2)

	-- draw enemies
	love.graphics.setColor(0,255,255,255)
	for i,v in ipairs(enemies) do
		love.graphics.rectangle("fill", v.x, v.y, v.width, v.height)
	end

	-- draw shots
	love.graphics.setColor(255,255,255,255)
	for i,v in ipairs(hero.shots) do
		love.graphics.rectangle("fill", v.x, v.y, 2, 5)
	end

end

function love.keypressed(key)
    if (key == " ") then
        shoot()
    end
	-- while (key == " ") do
        -- shoot()
    -- end
end

function love.keyreleased(key)
    if (key == " ") then
        shoot()
    end

	if (key == "1") then
        createEnemies(1)
	elseif (key == "2") then
        createEnemies(2)
	elseif (key == "3") then
        createEnemies(3)
	elseif (key == "4") then
        createEnemies(4)
	elseif (key == "5") then
        createEnemies(5)
	elseif (key == "6") then
        createEnemies(6)
	elseif (key == "7") then
        createEnemies(7)
    end

end

function CheckCollision(box1x, box1y, box1w, box1h, box2x, box2y, box2w, box2h)
	if box1x > box2x + box2w - 1 or -- Is box1 on the right side of box2?
	   box1y > box2y + box2h - 1 or -- Is box1 under box2?
	   box2x > box1x + box1w - 1 or -- Is box2 on the right side of box1?
	   box2y > box1y + box1h - 1    -- Is b2 under b1?
	then
		return false                -- No collision. Yay!
	else
		return true                 -- Yes collision. Ouch!
	end
end

function shoot()
	local shot = {}
	shot.x = hero.x+hero.width/2
	shot.y = hero.y
	table.insert(hero.shots, shot)
end

function createEnemies(choice)
	for i=0,choice-1 do
			enemy = {}
			enemy.width = 40
			enemy.height = 20
			enemy.x = i * (enemy.width + 60) + 100
			enemy.y = enemy.height + 100
			table.insert(enemies, enemy)
	end
end

function endGame(result)
	function love.draw()
		-- draw background
		love.graphics.setColor(255,255,255,255)
		love.graphics.draw(endLogo)

		if result == "lose" then
			love.graphics.print( "You Lose! Xur and the Ko-Dan Armada have prevailed!", 60, 300, 0, 2, 2)
		elseif result == "win" then
			love.graphics.print( "You Win! Congratulations, Last Starfighter!!!", 150, 300, 0, 2, 2)
		end

	end

end
