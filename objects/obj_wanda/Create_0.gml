/// @desc Initialise wanda.
image_speed = 0;
z = 0;
targetAngle = 0;
movementAngle = 0;
flip = false;
jumpTimer = -1;
allowJump = true;
jumpParity = false;
subimages = [
  {
      flip : true,
      idle : 6,
      walk : [6, 8, 6, 7],
      jump : [8, 7],
  },
  {
      flip : false,
      idle : 3,
      walk : [3, 4, 3, 5],
      jump : [4, 5],
  },
  {
      flip : false,
      idle : 6,
      walk : [6, 7, 6, 8],
      jump : [7, 8],
  },
  {
      flip : false,
      idle : 2,
      walk : [2, 1, 2, 0],
      jump : [1, 0],
  },
];