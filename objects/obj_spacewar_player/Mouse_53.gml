if (!can_shot) exit;
can_shot = false;
shotX = x;
shotY = y;
shotTargetX = mouse_x;
shotTargetY = mouse_y;
alarm[3] = 25; // Can shoot again
scr_spacewar_create_shot();
net_send_array(spacewar_msg.shot, all, [x, y, mouse_x, mouse_y], true);