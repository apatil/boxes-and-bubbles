import Mouse
import BoxesAndBubblesEngine (..)
import BoxesAndBubbles (..)
import Math2D (mul2)

inf = 1/0
e0 = 0.8

--box: (w,h) pos velocity density restitution 
--bubble: radius pos velocity density restitution

someBodies = [ 
  bubble 30 1 e0(-80,0) (1.5,0),
  bubble 70 inf 0 (80,0) (0,0) ,
  bubble 40 1 e0 (0,200) (0.4,-3.0),
  bubble 80 0.1 e0 (300,-280) (-2,1),
  bubble 15 5 0.4 (300,300) (-4,-3),
  bubble 40 1 e0 (200,200) (-5,-1),
  box (100,100) 1 e0 (300,0) (0,0),
  box (20,20) 1 e0 (-200,0) (3,0),
  box (20,40) 1 e0 (200,-200) (-1,-1)
  ] ++ bounds (750,750) 100 e0 (0,0)


bodyInfo restitution inverseMass = 
  ["e = ", show restitution, "\nm = ", show (round (1/inverseMass))] 
  |> concat |> toText |> centered |> toForm 

drawBody {pos,velocity,inverseMass,restitution,shape} = 
  let veloLine = segment (0,0) (mul2 velocity 5) |> traced (solid red)
      info = bodyInfo restitution inverseMass
      ready = case shape of
        Bubble radius ->
          group [
            circle radius |> outlined (solid black),
            veloLine, info |> move (0,radius+16)
            ]
        Box extents -> 
          let (w,h) = extents
          in group [
            rect (w*2) (h*2) |> outlined (solid black),
            veloLine, info |> move (0,h+16)
          ] 
  in move pos ready  

scene bodies = 
  let drawnBodies = map drawBody bodies 
  in collage 800 800 drawnBodies

constforce t = ((0,-0.2),(0,0))
sinforce t = ((sin <| radians (t/1000)) * 50, 0)
tick0 = constforce <~ foldp (+) 0 (fps 20)

main = scene <~ run someBodies tick0