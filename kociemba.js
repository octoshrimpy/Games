function warning(a, b) {
  document.getElementById("warningTitle").innerHTML = a, document.getElementById("ezigynemkirakhato").innerHTML = b, jQuery(".adbannerinvalidscramble").fadeIn(200), jQuery(".warningOverlay").fadeIn(100), jQuery("#pleasewait").hide()
}

function hideWarning() {
  jQuery(".adbannerinvalidscramble").hide(100), jQuery(".warningOverlay").hide(100)
}

function eventvan(a) {
  2 == a && (jQuery("#interactiveHelp").fadeOut(200), jQuery("#bubbleBottom").fadeOut(0)), 3 == a && (volumecontrolchanged(8), itsPlaybackTime = 0, document.getElementById("myplaybutton").style.backgroundPosition = "0px 0px", aktstep > 0 && eddigkiir(aktstep - 1)), 4 == a && (itsPlaybackTime = 1, document.getElementById("myplaybutton").style.backgroundPosition = "0px -184px", playTheSolution()), 5 == a && (itsPlaybackTime = 0, document.getElementById("myplaybutton").style.backgroundPosition = "0px 0px"), 6 == a && (itsPlaybackTime = 0, document.getElementById("myplaybutton").style.backgroundPosition = "0px 0px", eddigkiir(0), aktstep = 0), 7 == a && (volumecontrolchanged(8), itsPlaybackTime = 0, document.getElementById("myplaybutton").style.backgroundPosition = "0px 0px", aktstep < osszlepesszam && eddigkiir(aktstep + 1)), 8 == a && (jQuery(".wrapRotations").hide(), jQuery(".rotationswitcher").hide(), jQuery(".wrapRotaciok").fadeIn(500))
}

function kiiregyfieldecsket(a, b) {
  (b >= 10 && b <= 18 || b >= 46 && b <= 54 || b >= 19 && b <= 27 || b >= 37 && b <= 45) && (1 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb1")), 2 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb2")), 3 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb3")), 4 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb4")), 5 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb5")), 6 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocb6"))), b >= 28 && b <= 36 && (1 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba1")), 2 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba2")), 3 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba3")), 4 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba4")), 5 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba5")), 6 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocba6"))), b >= 1 && b <= 9 && (1 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb1")), 2 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb2")), 3 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb3")), 4 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb4")), 5 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb5")), 6 == a && (jQuery("#fieldecske" + b).removeClass(), jQuery("#fieldecske" + b).addClass("kocbb6")))
}

function kiiregymezocsket(a, b) {
  (b >= 1 && b <= 9 || b >= 46 && b <= 54) && (1 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd1")), 2 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd2")), 3 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd3")), 4 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd4")), 5 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd5")), 6 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmd6"))), (b >= 10 && b <= 18 || b >= 28 && b <= 36) && (1 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda1")), 2 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda2")), 3 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda3")), 4 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda4")), 5 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda5")), 6 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmda6"))), (b >= 19 && b <= 27 || b >= 37 && b <= 45) && (1 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb1")), 2 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb2")), 3 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb3")), 4 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb4")), 5 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb5")), 6 == a && (jQuery("#mezocske" + b).removeClass(), jQuery("#mezocske" + b).addClass("hrmdb6")))
}

function kiir() {
  for (i = 1; i <= 54; i++) 1 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#F6FB00"), 2 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#15FB00"), 3 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#FF7700"), 4 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#1F01FF"), 5 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#C70805"), 6 == a[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#E2DDDD"), kiiregymezocsket(a[i], i), kiiregyfieldecsket(a[i], i);
  rotklikk("letilt")
}

function kiirkics() {
  for (i = 1; i <= 54; i++) ai[i] = koz[kics[i]];
  for (i = 1; i <= 54; i++) 1 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#F6FB00"), 2 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#15FB00"), 3 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#FF7700"), 4 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#1F01FF"), 5 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#C70805"), 6 == ai[i] && (document.getElementById("mezo" + i).style.backgroundColor = "#E2DDDD"), kiiregymezocsket(ai[i], i), kiiregyfieldecsket(ai[i], i)
}

function playTheSolution() {
  osszlepesszam == aktstep && (itsPlaybackTime = 0, document.getElementById("myplaybutton").style.backgroundPosition = "0px 0px"), 1 == itsPlaybackTime && osszlepesszam > 0 && (aktstep += 1, eddigkiir(aktstep), t = setTimeout("playTheSolution()", cubeplaybackspeed))
}

function resetColors() {
  var b = selectedCol;
  for (selectedCol = 0, a[1] = 0, a[2] = 0, a[3] = 0, a[4] = 0, a[5] = 0, a[6] = 0, a[7] = 0, a[8] = 0, a[9] = 0, a[10] = 1, a[11] = 1, a[12] = 1, a[13] = 1, a[14] = 1, a[15] = 1, a[16] = 1, a[17] = 1, a[18] = 1, a[19] = 2, a[20] = 2, a[21] = 2, a[22] = 2, a[23] = 2, a[24] = 2, a[25] = 2, a[26] = 2, a[27] = 2, a[28] = 3, a[29] = 3, a[30] = 3, a[31] = 3, a[32] = 3, a[33] = 3, a[34] = 3, a[35] = 3, a[36] = 3, a[37] = 4, a[38] = 4, a[39] = 4, a[40] = 4, a[41] = 4, a[42] = 4, a[43] = 4, a[44] = 4, a[45] = 4, a[46] = 5, a[47] = 5, a[48] = 5, a[49] = 5, a[50] = 5, a[51] = 5, a[52] = 5, a[53] = 5, a[54] = 5, i = 1; i <= 54; i++) incr(a[i], "mezo" + i, i);
  a[1] = 1, a[2] = 1, a[3] = 1, a[4] = 1, a[5] = 1, a[6] = 1, a[7] = 1, a[8] = 1, a[9] = 1, a[10] = 2, a[11] = 2, a[12] = 2, a[13] = 2, a[14] = 2, a[15] = 2, a[16] = 2, a[17] = 2, a[18] = 2, a[19] = 3, a[20] = 3, a[21] = 3, a[22] = 3, a[23] = 3, a[24] = 3, a[25] = 3, a[26] = 3, a[27] = 3, a[28] = 4, a[29] = 4, a[30] = 4, a[31] = 4, a[32] = 4, a[33] = 4, a[34] = 4, a[35] = 4, a[36] = 4, a[37] = 5, a[38] = 5, a[39] = 5, a[40] = 5, a[41] = 5, a[42] = 5, a[43] = 5, a[44] = 5, a[45] = 5, a[46] = 6, a[47] = 6, a[48] = 6, a[49] = 6, a[50] = 6, a[51] = 6, a[52] = 6, a[53] = 6, a[54] = 6, selectedCol = b, rotklikk("zeroz")
}

function bor() {
  s[1] = a[1], s[2] = a[4], s[3] = a[7], a[1] = a[45], a[4] = a[42], a[7] = a[39], a[45] = a[46], a[42] = a[49], a[39] = a[52], a[46] = a[19], a[49] = a[22], a[52] = a[25], a[19] = s[1], a[22] = s[2], a[25] = s[3], s[1] = a[2], s[2] = a[5], s[3] = a[8], a[2] = a[44], a[5] = a[41], a[8] = a[38], a[44] = a[47], a[41] = a[50], a[38] = a[53], a[47] = a[20], a[50] = a[23], a[53] = a[26], a[20] = s[1], a[23] = s[2], a[26] = s[3], s[1] = a[3], s[2] = a[6], s[3] = a[9], a[3] = a[43], a[6] = a[40], a[9] = a[37], a[43] = a[48], a[40] = a[51], a[37] = a[54], a[48] = a[21], a[51] = a[24], a[54] = a[27], a[21] = s[1], a[24] = s[2], a[27] = s[3], s[1] = a[10], s[2] = a[11], a[10] = a[16], a[11] = a[13], a[16] = a[18], a[13] = a[17], a[18] = a[12], a[17] = a[15], a[12] = s[1], a[15] = s[2], s[1] = a[28], s[2] = a[29], a[28] = a[30], a[29] = a[33], a[30] = a[36], a[33] = a[35], a[36] = a[34], a[35] = a[31], a[34] = s[1], a[31] = s[2]
}

function rot() {
  s[1] = a[25], s[2] = a[26], s[3] = a[27], a[25] = a[16], a[26] = a[17], a[27] = a[18], a[16] = a[43], a[17] = a[44], a[18] = a[45], a[43] = a[34], a[44] = a[35], a[45] = a[36], a[34] = s[1], a[35] = s[2], a[36] = s[3], s[1] = a[46], s[2] = a[47], a[46] = a[52], a[47] = a[49], a[52] = a[54], a[49] = a[53], a[54] = a[48], a[53] = a[51], a[48] = s[1], a[51] = s[2]
}

function roti() {
  s[1] = a[25], s[2] = a[26], s[3] = a[27], a[25] = a[34], a[26] = a[35], a[27] = a[36], a[34] = a[43], a[35] = a[44], a[36] = a[45], a[43] = a[16], a[44] = a[17], a[45] = a[18], a[16] = s[1], a[17] = s[2], a[18] = s[3], s[1] = a[46], s[2] = a[47], a[46] = a[48], a[47] = a[51], a[48] = a[54], a[51] = a[53], a[54] = a[52], a[53] = a[49], a[52] = s[1], a[49] = s[2]
}

function fd() {
  s[1] = a[19], s[2] = a[20], s[3] = a[21], a[19] = a[28], a[20] = a[29], a[21] = a[30], a[28] = a[37], a[29] = a[38], a[30] = a[39], a[37] = a[10], a[38] = a[11], a[39] = a[12], a[10] = s[1], a[11] = s[2], a[12] = s[3], s[1] = a[22], s[2] = a[23], s[3] = a[24], a[22] = a[31], a[23] = a[32], a[24] = a[33], a[31] = a[40], a[32] = a[41], a[33] = a[42], a[40] = a[13], a[41] = a[14], a[42] = a[15], a[13] = s[1], a[14] = s[2], a[15] = s[3], s[1] = a[25], s[2] = a[26], s[3] = a[27], a[25] = a[34], a[26] = a[35], a[27] = a[36], a[34] = a[43], a[35] = a[44], a[36] = a[45], a[43] = a[16], a[44] = a[17], a[45] = a[18], a[16] = s[1], a[17] = s[2], a[18] = s[3], s[1] = a[1], s[2] = a[2], a[1] = a[7], a[2] = a[4], a[7] = a[9], a[4] = a[8], a[9] = a[3], a[8] = a[6], a[3] = s[1], a[6] = s[2], s[1] = a[46], s[2] = a[47], a[46] = a[48], a[47] = a[51], a[48] = a[54], a[51] = a[53], a[54] = a[52], a[53] = a[49], a[52] = s[1], a[49] = s[2]
}

function uu() {
  bor(), bor(), rot(), bor(), bor(), stp++, step[stp] = 1
}

function ui() {
  bor(), bor(), roti(), bor(), bor(), stp++, step[stp] = 2
}

function ff() {
  bor(), rot(), bor(), bor(), bor(), stp++, step[stp] = 5
}

function fi() {
  bor(), roti(), bor(), bor(), bor(), stp++, step[stp] = 6
}

function rr() {
  fd(), bor(), rot(), bor(), bor(), bor(), fd(), fd(), fd(), stp++, step[stp] = 7
}

function ri() {
  fd(), bor(), roti(), bor(), bor(), bor(), fd(), fd(), fd(), stp++, step[stp] = 8
}

function ll() {
  fd(), fd(), fd(), bor(), rot(), bor(), bor(), bor(), fd(), stp++, step[stp] = 3
}

function li() {
  fd(), fd(), fd(), bor(), roti(), bor(), bor(), bor(), fd(), stp++, step[stp] = 4
}

function dd() {
  rot(), stp++, step[stp] = 11
}

function di() {
  roti(), stp++, step[stp] = 12
}

function bb() {
  bor(), bor(), bor(), rot(), bor(), stp++, step[stp] = 9
}

function bi() {
  bor(), bor(), bor(), roti(), bor(), stp++, step[stp] = 10
}

function kiirarrayt() {
  document.getElementById("segedvaltozo").innerHTML = "<div class='hanysztep'>" + stp + " steps:</div> <span id='algoritmusHanyadik0' onclick='eddigkiir(0);'> >> </span>", document.getElementById("iframestepsamount").innerHTML = "Solved in " + stp + " steps.", document.getElementById("rotationhelper").style.backgroundPosition = "339px 0px", document.getElementById("rotationhelperzero").style.backgroundPosition = "339px 0px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "339px 0px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "339px 0px", osszlepesszam = stp;
  var a = "A";
  for (iframesteps = "moves=", i = 1; i <= stp; i++) String(document.domain).indexOf("ube-sol") == -1 && step[i] < 16 && (step[i] = step[i] + 1), 1 == step[i] && (iframesteps += "U", a = "U"), 2 == step[i] && (iframesteps += "u", a = "U&#39;"), 3 == step[i] && (iframesteps += "L", a = "L"), 4 == step[i] && (iframesteps += "l", a = "L&#39;"), 5 == step[i] && (iframesteps += "F", a = "F"), 6 == step[i] && (iframesteps += "f", a = "F&#39;"), 7 == step[i] && (iframesteps += "R", a = "R"), 8 == step[i] && (iframesteps += "r", a = "R&#39;"), 9 == step[i] && (iframesteps += "B", a = "B"), 10 == step[i] && (iframesteps += "b", a = "B&#39;"), 11 == step[i] && (iframesteps += "D", a = "D"), 12 == step[i] && (iframesteps += "d", a = "D&#39;"), 13 == step[i] && (iframesteps += "4", a = "U2"), 14 == step[i] && (iframesteps += "2", a = "L2"), 15 == step[i] && (iframesteps += "0", a = "F2"), 16 == step[i] && (iframesteps += "3", a = "R2"), 17 == step[i] && (iframesteps += "1", a = "B2"), 18 == step[i] && (iframesteps += "5", a = "D2"), document.getElementById("segedvaltozo").innerHTML = document.getElementById("segedvaltozo").innerHTML + " <span id='algoritmusHanyadik" + i + "' onclick='volumecontrolchanged(8);eddigkiir(" + i + ");'>" + a + "</span>"
}

function stepNullaz() {
  for (i = 1; i <= 150; i++) step[i] = 0, stp = 0
}

function kicsibor() {
  s[1] = kics[1], s[2] = kics[4], s[3] = kics[7], kics[1] = kics[45], kics[4] = kics[42], kics[7] = kics[39], kics[45] = kics[46], kics[42] = kics[49], kics[39] = kics[52], kics[46] = kics[19], kics[49] = kics[22], kics[52] = kics[25], kics[19] = s[1], kics[22] = s[2], kics[25] = s[3], s[1] = kics[2], s[2] = kics[5], s[3] = kics[8], kics[2] = kics[44], kics[5] = kics[41], kics[8] = kics[38], kics[44] = kics[47], kics[41] = kics[50], kics[38] = kics[53], kics[47] = kics[20], kics[50] = kics[23], kics[53] = kics[26], kics[20] = s[1], kics[23] = s[2], kics[26] = s[3], s[1] = kics[3], s[2] = kics[6], s[3] = kics[9], kics[3] = kics[43], kics[6] = kics[40], kics[9] = kics[37], kics[43] = kics[48], kics[40] = kics[51], kics[37] = kics[54], kics[48] = kics[21], kics[51] = kics[24], kics[54] = kics[27], kics[21] = s[1], kics[24] = s[2], kics[27] = s[3], s[1] = kics[10], s[2] = kics[11], kics[10] = kics[16], kics[11] = kics[13], kics[16] = kics[18], kics[13] = kics[17], kics[18] = kics[12], kics[17] = kics[15], kics[12] = s[1], kics[15] = s[2], s[1] = kics[28], s[2] = kics[29], kics[28] = kics[30], kics[29] = kics[33], kics[30] = kics[36], kics[33] = kics[35], kics[36] = kics[34], kics[35] = kics[31], kics[34] = s[1], kics[31] = s[2]
}

function kicsirot() {
  s[1] = kics[25], s[2] = kics[26], s[3] = kics[27], kics[25] = kics[16], kics[26] = kics[17], kics[27] = kics[18], kics[16] = kics[43], kics[17] = kics[44], kics[18] = kics[45], kics[43] = kics[34], kics[44] = kics[35], kics[45] = kics[36], kics[34] = s[1], kics[35] = s[2], kics[36] = s[3], s[1] = kics[46], s[2] = kics[47], kics[46] = kics[52], kics[47] = kics[49], kics[52] = kics[54], kics[49] = kics[53], kics[54] = kics[48], kics[53] = kics[51], kics[48] = s[1], kics[51] = s[2]
}

function kicsiroti() {
  s[1] = kics[25], s[2] = kics[26], s[3] = kics[27], kics[25] = kics[34], kics[26] = kics[35], kics[27] = kics[36], kics[34] = kics[43], kics[35] = kics[44], kics[36] = kics[45], kics[43] = kics[16], kics[44] = kics[17], kics[45] = kics[18], kics[16] = s[1], kics[17] = s[2], kics[18] = s[3], s[1] = kics[46], s[2] = kics[47], kics[46] = kics[48], kics[47] = kics[51], kics[48] = kics[54], kics[51] = kics[53], kics[54] = kics[52], kics[53] = kics[49], kics[52] = s[1], kics[49] = s[2]
}

function kicsifd() {
  s[1] = kics[19], s[2] = kics[20], s[3] = kics[21], kics[19] = kics[28], kics[20] = kics[29], kics[21] = kics[30], kics[28] = kics[37], kics[29] = kics[38], kics[30] = kics[39], kics[37] = kics[10], kics[38] = kics[11], kics[39] = kics[12], kics[10] = s[1], kics[11] = s[2], kics[12] = s[3], s[1] = kics[22], s[2] = kics[23], s[3] = kics[24], kics[22] = kics[31], kics[23] = kics[32], kics[24] = kics[33], kics[31] = kics[40], kics[32] = kics[41], kics[33] = kics[42], kics[40] = kics[13], kics[41] = kics[14], kics[42] = kics[15], kics[13] = s[1], kics[14] = s[2], kics[15] = s[3], s[1] = kics[25], s[2] = kics[26], s[3] = kics[27], kics[25] = kics[34], kics[26] = kics[35], kics[27] = kics[36], kics[34] = kics[43], kics[35] = kics[44], kics[36] = kics[45], kics[43] = kics[16], kics[44] = kics[17], kics[45] = kics[18], kics[16] = s[1], kics[17] = s[2], kics[18] = s[3], s[1] = kics[1], s[2] = kics[2], kics[1] = kics[7], kics[2] = kics[4], kics[7] = kics[9], kics[4] = kics[8], kics[9] = kics[3], kics[8] = kics[6], kics[3] = s[1], kics[6] = s[2], s[1] = kics[46], s[2] = kics[47], kics[46] = kics[48], kics[47] = kics[51], kics[48] = kics[54], kics[51] = kics[53], kics[54] = kics[52], kics[53] = kics[49], kics[52] = s[1], kics[49] = s[2]
}

function kicsiuu() {
  kicsibor(), kicsibor(), kicsirot(), kicsibor(), kicsibor()
}

function kicsiui() {
  kicsibor(), kicsibor(), kicsiroti(), kicsibor(), kicsibor()
}

function kicsiff() {
  kicsibor(), kicsirot(), kicsibor(), kicsibor(), kicsibor()
}

function kicsifi() {
  kicsibor(), kicsiroti(), kicsibor(), kicsibor(), kicsibor()
}

function kicsirr() {
  kicsifd(), kicsibor(), kicsirot(), kicsibor(), kicsibor(), kicsibor(), kicsifd(), kicsifd(), kicsifd()
}

function kicsiri() {
  kicsifd(), kicsibor(), kicsiroti(), kicsibor(), kicsibor(), kicsibor(), kicsifd(), kicsifd(), kicsifd()
}

function kicsill() {
  kicsifd(), kicsifd(), kicsifd(), kicsibor(), kicsirot(), kicsibor(), kicsibor(), kicsibor(), kicsifd()
}

function kicsili() {
  kicsifd(), kicsifd(), kicsifd(), kicsibor(), kicsiroti(), kicsibor(), kicsibor(), kicsibor(), kicsifd()
}

function kicsidd() {
  kicsirot()
}

function kicsidi() {
  kicsiroti()
}

function kicsibb() {
  kicsibor(), kicsibor(), kicsibor(), kicsirot(), kicsibor(), stp++, step[stp] = 9
}

function kicsibi() {
  kicsibor(), kicsibor(), kicsibor(), kicsiroti(), kicsibor(), stp++, step[stp] = 10
}

function eddigkiir(a) {
  aktstep = a;
  var b = "orient";
  for (drawszlider(osszlepesszam, a), 1 == step[a] && (b = "U"), 2 == step[a] && (b = "U'"), 3 == step[a] && (b = "L"), 4 == step[a] && (b = "L'"), 5 == step[a] && (b = "F"), 6 == step[a] && (b = "F'"), 7 == step[a] && (b = "R"), 8 == step[a] && (b = "R'"), 9 == step[a] && (b = "B"), 10 == step[a] && (b = "B'"), 11 == step[a] && (b = "D"), 12 == step[a] && (b = "D'"), 13 == step[a] && (b = "U2"), 14 == step[a] && (b = "L2"), 15 == step[a] && (b = "F2"), 16 == step[a] && (b = "R2"), 17 == step[a] && (b = "B2"), 18 == step[a] && (b = "D2"), document.getElementById("rotacioSzoveg").innerHTML = a + "<span>" + b + "</span>", 0 == a && (document.getElementById("rotacioSzoveg").innerHTML = "Orient", document.getElementById("rotationhelper").style.backgroundPosition = "339px 0px", document.getElementById("rotationhelperzero").style.backgroundPosition = "339px 0px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "339px 0px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "339px 0px"), step[a] > 12 ? a > 0 && (jQuery("#vigyazzKetszer").show(), jQuery("#vigyazzKetszerMobil").show()) : (jQuery("#vigyazzKetszer").hide(), jQuery("#vigyazzKetszerMobil").hide()), document.getElementById("algoritmusHanyadik" + elozorot).style.backgroundColor = "transparent", document.getElementById("algoritmusHanyadik" + a).style.backgroundColor = "#BE3B32", elozorot = a, step[0] = 0, 1 == helpcheck && (1 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px 0px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-1px 1px"), 2 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px 0px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-129px 1px"), 3 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -243px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -121px"), 4 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -243px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-128px -121px"), 5 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -486px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "1px -244px"), 6 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -486px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-128px -244px"), 7 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -729px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -365px"), 8 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -729px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-128px -365px"), 9 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -994px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -497px"), 10 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -994px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-128px -497px"), 11 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -1215px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -607px"), 12 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -1215px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-128px -607px"), 13 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px 0px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "-1px 1px"), 14 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -243px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -121px"), 15 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -486px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "1px -244px"), 16 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -729px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -365px"), 17 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -994px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -497px"), 18 == step[a] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -1215px", document.getElementById("kicsi-haromd-rots").style.backgroundPosition = "0px -607px"), 1 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -237px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px -119px"), 2 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 0px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px 0px"), 3 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -1166px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-41px -583px"), 4 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -928px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-41px -464px"), 5 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -404px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-30px -202px"), 6 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -634px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-30px -317px"), 7 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -926px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -463px"), 8 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -1164px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -582px"), 9 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -696px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -348px"), 10 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -466px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -233px"), 11 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 82px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px 41px"), 12 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -155px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px -78px"), 13 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -237px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px -119px"), 14 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -1166px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-41px -583px"), 15 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -404px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-30px -202px"), 16 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -926px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -463px"), 17 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -696px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "-1px -348px"), 18 == step[a] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 82px", document.getElementById("kicsi-kociemba-rots").style.backgroundPosition = "0px 41px")), i = 1; i <= 54; i++) kics[i] = orig[i];
  if (appletcolorscheme = "yworgb", 0 == a)
  for (i = 1; i <= 54; i++) haromd[i] = kics[i];
  for (ij = 0; ij <= a; ij++) 1 == step[ij] && kicsiuu(), 2 == step[ij] && kicsiui(), 3 == step[ij] && kicsill(), 4 == step[ij] && kicsili(), 5 == step[ij] && kicsiff(), 6 == step[ij] && kicsifi(), 7 == step[ij] && kicsirr(), 8 == step[ij] && kicsiri(), 9 == step[ij] && kicsibb(), 10 == step[ij] && kicsibi(), 11 == step[ij] && kicsidd(), 12 == step[ij] && kicsidi(), 13 == step[ij] && (kicsiuu(), kicsiuu()), 14 == step[ij] && (kicsill(), kicsill()), 15 == step[ij] && (kicsiff(), kicsiff()), 16 == step[ij] && (kicsirr(), kicsirr()), 17 == step[ij] && (kicsibb(), kicsibb()), 18 == step[ij] && (kicsidd(), kicsidd());
  t = setTimeout("if(showingTheSolution == 1) {kiirkics()}", Math.round(cubeplaybackspeed / 2.5))
}

function kociembaFieldsTransform() {
  var b = "",
  d = new Array,
  e = new Array,
  f = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 37, 38, 39, 40, 41, 42, 43, 44, 45, 19, 20, 21, 22, 23, 24, 25, 26, 27, 10, 11, 12, 13, 14, 15, 16, 17, 18, 46, 47, 48, 49, 50, 51, 52, 53, 54, 28, 29, 30, 31, 32, 33, 34, 35, 36];
  for (kind = 1; kind <= 54; kind++) d[kind] = 0, 1 == a[kind] && (d[kind] = "U"), 2 == a[kind] && (d[kind] = "L"), 3 == a[kind] && (d[kind] = "F"), 4 == a[kind] && (d[kind] = "R"), 5 == a[kind] && (d[kind] = "B"), 6 == a[kind] && (d[kind] = "D");
  for (kind = 1; kind <= 54; kind++) e[f[kind]] = d[kind];
  for (kind = 1; kind <= 54; kind++) b += d[kind];
  for (b = "", kind = 1; kind <= 54; kind++) b += e[kind];
  $("#cube").val(b)
}

function kociembasolve() {
  var b = 0;
  for (1 == a[14] && (fd(), bor()), 1 == a[23] && (bor(), bor(), bor()), 1 == a[32] && (fd(), fd(), fd(), bor()), 1 == a[41] && bor(), 1 == a[50] && (bor(), bor()), 3 == a[32] && fd(), 3 == a[41] && (fd(), fd()), 3 == a[14] && (fd(), fd(), fd()), i = 1; i <= 54; i++) orig[i] = a[i];
  var c = 0;
  1 == a[5] && 2 == a[14] && 3 == a[23] && 4 == a[32] && 5 == a[41] && 6 == a[50] || (c = 1, warning("Unusual color scheme", 'Sorry but the optimal solver supports only the standard color scheme. Please <a href="https://rubiks-cube-solver.com/layer-by-layer.php?cube=' + urlkocka + '&x=66">click here</a> for the layer-by-layer solution.')), 0 == c && (1 == a[1] && 5 == a[2] && 1 == a[3] && 2 == a[4] && 4 == a[6] && 1 == a[7] && 3 == a[8] && 1 == a[9] && 2 == a[10] && 1 == a[11] && 2 == a[12] && 5 == a[13] && 3 == a[15] && 2 == a[16] && 6 == a[17] && 2 == a[18] && 3 == a[19] && 1 == a[20] && 3 == a[21] && 2 == a[22] && 4 == a[24] && 3 == a[25] && 6 == a[26] && 3 == a[27] && 4 == a[28] && 1 == a[29] && 4 == a[30] && 3 == a[31] && 5 == a[33] && 4 == a[34] && 6 == a[35] && 4 == a[36] && 5 == a[37] && 1 == a[38] && 5 == a[39] && 4 == a[40] && 2 == a[42] && 5 == a[43] && 6 == a[44] && 5 == a[45] && 6 == a[46] && 3 == a[47] && 6 == a[48] && 2 == a[49] && 4 == a[51] && 6 == a[52] && 5 == a[53] && 6 == a[54] && (b = 1, stp = 20, step = [0, 1, 16, 5, 9, 7, 17, 7, 13, 3, 17, 7, 2, 12, 16, 5, 8, 3, 17, 13, 15]), 0 == b ? (document.getElementById("layerByLayerLink").innerHTML = "If you don't want to wait you can get the long layer-by-layer solution <a href=\"https://rubiks-cube-solver.com/layer-by-layer.php?cube=" + urlkocka + '&x=70">here</a>', worker.postMessage({
    type: "generateTables"
  }), document.getElementById("progress").hidden = !1, document.getElementById("generate").hidden = !0, kociembaFieldsTransform(), stepNullaz(), stp = 0, minprob = 1, osszlepesszam = 0) : (kiirarrayt(), eddigkiir(0), document.getElementById("progress").hidden = !1, document.getElementById("generate").hidden = !0, jQuery("#pleasewait").hide(), jQuery("#helpercheckbox").show(), jQuery("#fulecske3").show()))
}

function thinkAndSolve() {
  showingTheSolution = 1, document.getElementById("segedvaltozo").innerHTML = "", t = setTimeout("kociembasolve()", 50)
}

function update3DPreview() {
  for (iframescheme = "fields=", i = 1; i < 55; i++) 1 == a[i] && (iframescheme += "y"), 2 == a[i] && (iframescheme += "g"), 3 == a[i] && (iframescheme += "o"), 4 == a[i] && (iframescheme += "b"), 5 == a[i] && (iframescheme += "r"), 6 == a[i] && (iframescheme += "w");
  document.getElementById("iframe3Dpreview").innerHTML = '<iframe height="200" width="300px" scrolling="no" frameborder="0" src="https://rubiks3x3.com/algorithm/?rcs=prev&' + iframescheme + '&sett=010000&bg=888888"></iframe>'
}

function update3DSolution() {
  for (i = 1; i < 55; i++) 1 == haromd[i] && (iframescheme += "y"), 2 == haromd[i] && (iframescheme += "g"), 3 == haromd[i] && (iframescheme += "o"), 4 == haromd[i] && (iframescheme += "b"), 5 == haromd[i] && (iframescheme += "r"), 6 == haromd[i] && (iframescheme += "w");
  document.getElementById("iframe3Dpreview").innerHTML = '<iframe height="350" width="300px" scrolling="no" frameborder="0" src="https://rubiks3x3.com/algorithm/?rcs=solve&' + iframesteps + "&" + iframescheme + '&bg=888888&sett=011100"></iframe> '
}

function aktivfulecske(a) {
  0 == a ? (document.getElementById("vigyazzKetszer").style.left = "-315px", document.getElementById("vigyazzKetszer").style.top = "-343px", document.getElementById("fulecske0").style.backgroundColor = "#888889") : document.getElementById("fulecske0").style.backgroundColor = "#c0b0b0", 1 == a ? (document.getElementById("vigyazzKetszer").style.left = "0px", document.getElementById("vigyazzKetszer").style.top = "-215px", document.getElementById("fulecske1").style.backgroundColor = "#888889") : document.getElementById("fulecske1").style.backgroundColor = "#c0b0b0", 2 == a ? (document.getElementById("vigyazzKetszer").style.left = "-60px", document.getElementById("vigyazzKetszer").style.top = "-340px", document.getElementById("fulecske2").style.backgroundColor = "#888889") : document.getElementById("fulecske2").style.backgroundColor = "#c0b0b0", a > 2 ? document.getElementById("fulecske3").style.backgroundColor = "#888889" : document.getElementById("fulecske3").style.backgroundColor = "#c0b0b0", 0 == a && (jQuery("#kocka0Kontainer").fadeIn(350), jQuery("#kockaKontainer").hide(), jQuery("#kocka2Kontainer").hide(), jQuery("#kockaSegitseg").hide(), jQuery("#kocka3Kontainer").hide(), jQuery("#nemMegoldastKiiro").show(), jQuery(".kockaKontainerBelow").show(), jQuery("#megoldastKiiro").show()), 1 == a && (jQuery("#kocka2Kontainer").fadeIn(350), jQuery("#kockaKontainer").hide(), jQuery("#kocka0Kontainer").hide(), jQuery("#kockaSegitseg").hide(), jQuery("#kocka3Kontainer").hide(), jQuery("#nemMegoldastKiiro").show(), jQuery(".kockaKontainerBelow").show(), jQuery("#megoldastKiiro").show()), 2 == a && (jQuery("#kockaKontainer").fadeIn(350), jQuery("#kocka2Kontainer").hide(), jQuery("#kocka0Kontainer").hide(), jQuery("#kockaSegitseg").hide(), jQuery("#kocka3Kontainer").hide(), jQuery("#nemMegoldastKiiro").show(), jQuery(".kockaKontainerBelow").show(), jQuery("#megoldastKiiro").show()), 3 == a && (jQuery("#kocka3Kontainer").fadeIn(350), jQuery("#kocka2Kontainer").hide(), jQuery("#kocka0Kontainer").hide(), jQuery("#kockaSegitseg").hide(), jQuery("#kockaKontainer").hide(), jQuery("#nemMegoldastKiiro").hide(), jQuery(".kockaKontainerBelow").hide(), update3DPreview()), 33 == a && (jQuery("#kocka3Kontainer").fadeIn(350), jQuery("#kocka2Kontainer").hide(), jQuery("#kocka0Kontainer").hide(), jQuery("#kockaSegitseg").hide(), jQuery("#kockaKontainer").hide(), jQuery("#nemMegoldastKiiro").hide(), jQuery(".kockaKontainerBelow").hide(), jQuery("#megoldastKiiro").hide(), update3DSolution())
}

function drawszlider(a, b) {
  var c = 100;
  0 != a && (c = Math.round(100 * b / a)), document.getElementById("szliderbar").style.width = c + "%", document.getElementById("szazalek").innerHTML = c + "%"
}

function drawvolumecontroller(a, b, c) {
  for (document.getElementById("volumcontroller").innerHTML = "", i = 0; i < a; i++) magassag = 10 + Math.round(1.8 * (a - i)), margintop = b - magassag, margintop <= 0 && (margintop = 0), i >= c ? document.getElementById("volumcontroller").innerHTML = document.getElementById("volumcontroller").innerHTML + '<div  onmouseup="volumecontrolchanged(' + i + ')" style="background-color:#BE3B32;height:' + magassag + "px;margin-top:" + margintop + 'px;" class="volumecontrollerbar"></div>' : document.getElementById("volumcontroller").innerHTML = document.getElementById("volumcontroller").innerHTML + '<div  onmouseup="volumecontrolchanged(' + i + ')" style="height:' + magassag + "px;margin-top:" + margintop + 'px;" class="volumecontrollerbar"></div>'
}

function volumecontrolchanged(a) {
  drawvolumecontroller(13, 35, a);
  var b = "1 s/rot";
  0 == a && (b = "lightspeed", cubeplaybackspeed = 10), 1 == a && (b = "super&nbsp;fast", cubeplaybackspeed = 100), 2 == a && (b = "5&nbsp;rot/s", cubeplaybackspeed = 200), 3 == a && (b = "2&nbsp;rot/s", cubeplaybackspeed = 400), 4 == a && (b = "0.8&nbsp;s/rot", cubeplaybackspeed = 750), 5 == a && (b = "1&nbsp;rot/s", cubeplaybackspeed = 1e3), 6 == a && (b = "1.5&nbsp;s/rot", cubeplaybackspeed = 1500), 7 == a && (b = "2&nbsp;s/rot", cubeplaybackspeed = 2e3), 8 == a && (b = "2.5&nbsp;s/rot", cubeplaybackspeed = 2500), 9 == a && (b = "3&nbsp;s/rot", cubeplaybackspeed = 3e3), 10 == a && (b = "5&nbsp;s/rot", cubeplaybackspeed = 5e3), 11 == a && (b = "8&nbsp;s/rot", cubeplaybackspeed = 8e3), 12 == a && (b = "12&nbsp;s/rot", cubeplaybackspeed = 12e3), document.getElementById("volumeindicator").innerHTML = b
}

function checkedhelp() {
  1 == helpcheck ? (helpcheck = 0, helpcheck = 0, document.getElementById("helpercheckbox").style.backgroundPosition = "0px -29px", document.getElementById("rotationhelper").style.backgroundPosition = "339px 0px", document.getElementById("rotationhelperzero").style.backgroundPosition = "339px 0px") : (helpcheck = 1, document.getElementById("helpercheckbox").style.backgroundPosition = "0px 0px",
  1 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px 0px"), 2 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px 0px"), 3 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -243px"), 4 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -243px"), 5 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -486px"), 6 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -486px"), 7 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -729px"), 8 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -729px"), 9 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "1px -994px"), 10 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-257px -994px"), 11 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -1215px"), 12 == step[aktstep] && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -1215px"), 1 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -237px"), 2 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 0px"), 3 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -1166px"), 4 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -926px"), 5 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -404px"), 6 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -634px"), 7 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -926px"), 8 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -1164px"), 9 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -696px"), 10 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -466px"), 11 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 82px"), 12 == step[aktstep] && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -155px"))
}

function segitsegetBerajzol(a) {
  1 == helpcheck && (1 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px 0px"), 2 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px 0px"), 3 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -243px"), 4 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -243px"), 5 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -486px"), 6 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -486px"), 7 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -729px"), 8 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -729px"), 9 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -994px"), 10 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -994px"), 11 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "0px -1215px"), 12 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-256px -1215px"), 13 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "37px -229px"), 14 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-218px -227px"), 15 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-2px -1256px"), 16 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-257px -1256px"), 17 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-288px -979px"), 18 == a && (document.getElementById("rotationhelper").style.backgroundPosition = "-30px -979px"), jQuery("#rotationhelper").show(10), 1 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -237px"), 2 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 0px"), 3 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -1166px"), 4 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-82px -928px"), 5 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -404px"), 6 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-59px -634px"), 7 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -926px"), 8 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -1164px"), 9 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -696px"), 10 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-2px -466px"), 11 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 82px"), 12 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -155px"), 13 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-43px -1166px"), 14 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-42px -926px"), 15 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px 40px"), 16 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "0px -197px"), 17 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-31px -435px"), 18 == a && (document.getElementById("rotationhelperzero").style.backgroundPosition = "-31px -665px"), jQuery("#rotationhelperzero").show(10))
}

function segitsegetEltuntet() {
  document.getElementById("rotationhelper").style.backgroundPosition = "333px 0px", jQuery("#rotationhelper").hide(), document.getElementById("rotationhelperzero").style.backgroundPosition = "333px 0px", jQuery("#rotationhelperzero").hide()
}

function getUrlVars() {
  var a = {};
  window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/gi, function(b, c, d) {
    a[c] = d
  });
  return a
}

function initnotscrambled() {
  a[1] = 1, a[2] = 1, a[3] = 1, a[4] = 1, a[5] = 1, a[6] = 1, a[7] = 1, a[8] = 1, a[9] = 1, a[10] = 2, a[11] = 2, a[12] = 2, a[13] = 2, a[14] = 2, a[15] = 2, a[16] = 2, a[17] = 2, a[18] = 2, a[19] = 3, a[20] = 3, a[21] = 3, a[22] = 3, a[23] = 3, a[24] = 3, a[25] = 3, a[26] = 3, a[27] = 3, a[28] = 4, a[29] = 4, a[30] = 4, a[31] = 4, a[32] = 4, a[33] = 4, a[34] = 4, a[35] = 4, a[36] = 4, a[37] = 5, a[38] = 5, a[39] = 5, a[40] = 5, a[41] = 5, a[42] = 5, a[43] = 5, a[44] = 5, a[45] = 5, a[46] = 6, a[47] = 6, a[48] = 6, a[49] = 6, a[50] = 6, a[51] = 6, a[52] = 6, a[53] = 6, a[54] = 6
}

function szetdarabolurlt() {
  return urlkocka = getUrlVars().cube, void 0 == urlkocka && (urlkocka = "0111111111222222222333333333444444444555555555666666666"), "0111111111222222222333333333444444444555555555666666666" == urlkocka ? (document.getElementById("segedvaltozo").innerHTML = "<strong>You haven't set up the scrambled cube. <br />Please go back and do so.<br />If you need help read the description. </strong>", jQuery("#megoldastKiiro").show(), initnotscrambled(), kiir(), jQuery("#pleasewait").hide(), 0) : (initnotscrambled(), a = urlkocka.split(""), thinkAndSolve(), jQuery("#rotationhelper").show(), jQuery("#rotationhelperzero").show(), void(showingTheSolution = 1))
}

function rotklikk(b) {
  "zeroz" == b && (scramblerec = 1, scramblestr = "moves="), "letilt" == b && (scramblerec = 0, scramblestr = "moves="), "zeroz" != b && "letilt" != b && "update" != b && 1 == scramblerec && (scramblestr += b), sss = "";
  for (var c = 1; c < 55; c++) sss += a[c]
}

function getQueryString(a) {
  for (var b = {}, c = a.split("&"), d = 0; d < c.length; d++) {
    var e = c[d].split("="),
    f = e.shift(),
    g = e.join("=");
    g = !g || ("true" == g.toLowerCase() || "false" != g.toLowerCase() && unescape(g).replace(/\+/g, " ")), b[f] = g
  }
  return b
}

function typedToArray(a) {
  for (var b = [], c = 0; c < a.length; c++) b.push(c);
  return b
}

function buildOutput(a) {
  var b = document.getElementById("solution");
  b.moveset = a, b.innerHTML = "";
  for (var c = 0; c < a.length; c++) {
    var d = document.createElement("span");
    d.innerHTML = a[c].text, d.move = a[c], d.className = 0 == c ? "current move" : "move", b.appendChild(d), a[c].el = d
  }
  stp = a.length;
  for (var c = 0; c < a.length; c++) "U" == a[c].text && (step[c + 1] = 1), "U'" == a[c].text && (step[c + 1] = 2), "L" == a[c].text && (step[c + 1] = 3), "L'" == a[c].text && (step[c + 1] = 4), "F" == a[c].text && (step[c + 1] = 5), "F'" == a[c].text && (step[c + 1] = 6), "R" == a[c].text && (step[c + 1] = 7), "R'" == a[c].text && (step[c + 1] = 8), "B" == a[c].text && (step[c + 1] = 9), "B'" == a[c].text && (step[c + 1] = 10), "D" == a[c].text && (step[c + 1] = 11), "D'" == a[c].text && (step[c + 1] = 12), "U2" == a[c].text && (step[c + 1] = 13), "L2" == a[c].text && (step[c + 1] = 14), "F2" == a[c].text && (step[c + 1] = 15), "R2" == a[c].text && (step[c + 1] = 16), "B2" == a[c].text && (step[c + 1] = 17), "D2" == a[c].text && (step[c + 1] = 18);
  kiirarrayt(), eddigkiir(0), jQuery("#pleasewait").hide(), jQuery("#helpercheckbox").show(), jQuery("#fulecske3").show()
}

function makeQueryString(a, b, c) {
  var d = c ? "?" : "",
  e = !1;
  for (var f in a) a.hasOwnProperty(f) && (b && 0 == a[f] || (e = !0, d += encodeURIComponent(f) + "=" + encodeURIComponent(a[f]) + "&"));
  return e ? d.substring(0, d.length - 1) : ""
}

function popState(a) {
  var b = a.state;
  if (b) {
    var c = document.getElementById("cube");
    if (b.cube && ("clean" == b.cube ? cleanCube(!0) : "clear" == b.cube ? clearFacelets(!0) : "random" == b.cube ? worker.postMessage({
      type: "random"
    }) : 54 == b.cube.length && (c.value = b.cube, setInput.apply(c))), b.solution) {
      var d = b.solution.replace(/_/g, " ");
      if (Cube.validateMoveset(d)) {
        var e = Cube.movesetToArray(d);
        buildOutput(e)
      } else console.log("Invalid Moveset in the URL!")
    }
  }
}

function pushState() {}

function setCubeText() {
  isRandom = !1;
  for (var a = "", b = document.getElementById("cube"), c = 0; c < facelets.length; c++) {
    if ("" == document.getElementById(facelets[c]).color) return void(b.value = "");
    a += document.getElementById(facelets[c]).color
  }
  1 == document.getElementById("autocomplete").checked ? (a = Cube.autocompleteCube(a), b.value = a, setInput()) : b.value = a, pushState()
}

function setInput() {
  isRandom = !1;
  var a = document.getElementById("cube");
  if (54 == a.value.length)
  for (var b = a.value.split(""), c = 0; c < 54; c++) {
    var d = facelets[c],
    e = document.getElementById(d);
    e.color = b[c], e.style.backgroundColor = colorNames[b[c]]
  }
}

function clearFacelets(a) {
  isRandom = !1, document.getElementById("cube").value = "____U________R________F________D________L________B____";
  for (var b = 0; b < facelets.length; b++) {
    var c = document.getElementById(facelets[b]);
    c.classList.contains("center") || (c.color = "_", c.style.backgroundColor = colorNames._)
  }
  a !== !0 && pushState()
}

function cleanCube(a) {
  isRandom = !1;
  for (var b = 0; b < facelets.length; b++) {
    var c = document.getElementById(facelets[b]);
    c.classList.contains("center") || (c.color = facelets[b].substring(0, 1), c.style.backgroundColor = colorNames[c.color])
  }
  document.getElementById("cube").value = "UUUUUUUUURRRRRRRRRFFFFFFFFFDDDDDDDDDLLLLLLLLLBBBBBBBBB", a !== !0 && pushState()
}

function setColor() {
  this.classList.contains("center") ? (currentColor = this.color, document.getElementById("currentColor").color = currentColor, document.getElementById("currentColor").style.backgroundColor = colorNames[currentColor]) : (this.color = currentColor, this.style.backgroundColor = colorNames[currentColor], setCubeText())
}

function calculateChanges(a) {
  var c, d, e, f, b = {
    from: [],
    to: []
  },
  g = a.direction;
  "U" == a.face ? (c = "y", d = "x", e = "z", f = 2) : "R" == a.face ? (c = "x", d = "z", e = "y", f = 2, g *= -1) : "F" == a.face ? (c = "z", d = "x", e = "y", f = 0) : "D" == a.face ? (c = "y", d = "z", e = "x", f = 0, g *= -1) : "L" == a.face ? (c = "x", d = "y", e = "z", f = 0) : "B" == a.face && (c = "z", d = "y", e = "x", f = 2, g *= -1);
  for (var h = {
    x: [2, 5, 3, 4],
    y: [1, 5, 0, 4],
    z: [0, 2, 1, 3]
  }[c], i = 2 - g, j = b.faceMoves = [0, 1, 2, 3, 4, 5], k = 0; k < i; k++)
  for (var l = j.slice(), m = 0; m < 4; m++) j[h[m]] = l[h[(m + 1) % 4]];
  for (var k = 0; k < 9; k++) {
    var n = {},
    o = {};
    n[c] = f, n[d] = k % 3, n[e] = k / 3 | 0, b.from.push(n), o[c] = f, 0 == a.direction ? (o[d] = 2 - k % 3, o[e] = 2 - (k / 3 | 0)) : 1 == a.direction ? (o[d] = k / 3 | 0, o[e] = 2 - k % 3) : a.direction == -1 && (o[d] = 2 - (k / 3 | 0), o[e] = k % 3), b.to.push(o)
  }
  return b
}

function setColorNames() {
  localStorage.colorNames = JSON.stringify(colorNames)
}

function getColorNames() {
  colorNames = localStorage.colorNames ? JSON.parse(localStorage.colorNames) : {
    U: "#FFFF00",
    R: "#008000",
    F: "#FF0000",
    L: "#0000FF",
    D: "#FFFFFF",
    B: "#FFA500",
    _: "#808080"
  };
  for (var a in colorNames) {
    var b = document.getElementById(a + "Color");
    if (b) {
      b.value = colorNames[a];
      var c = document.createEvent("HTMLEvents");
      c.initEvent("input", !0, !0), b.dispatchEvent(c)
    }
  }
}

function resetColorNames() {
  localStorage.colorNames = "", getColorNames(), setInput.apply(document.getElementById("cube"))
}

function setColors(a) {
  colorNames[this.getAttribute("data-side")] = this.value, setInput.apply(document.getElementById("cube")), setColorNames()
}

function setColorBlank() {
  currentColor = "_", document.getElementById("currentColor").color = currentColor, document.getElementById("currentColor").style.backgroundColor = colorNames[currentColor]
}
var iframescheme = "fields=",
iframesteps = "moves=UDLRFBudlrfb",
selectedCol = 0,
megprobalKirakniEnnyiLepesben = 20,
klicked = 0,
i = 0,
minprob = 1,
prob = 1,
helpcheck = 1,
aktstep = 1,
osszlepesszam = 0,
step = new Array,
a = new Array,
koz = [0, 1, 2, 3, 4, 5, 6],
aa = new Array,
s = new Array,
ai = new Array,
haromd = new Array,
kics = new Array,
orig = new Array,
cubeplaybackspeed = 2e3,
itsPlaybackTime = 0,
showingTheSolution = 0,
elozorot = 0,
stp = 0,
t = 0,
appletcolorscheme = "yworgb",
showKetDkockaHelp = 0,
showImageGenerator = 0,
urlkocka = "0111111111222222222333333333444444444555555555666666666",
sss = "<a></a>",
scramblerec = 1,
scramblestr = "moves=";
"object" == typeof Cube || function() {
  window.Cube = {
    worker: new Worker("RubikWorker.js"),
    tablesGenerated: !1,
    movesetToArray: function(a) {
      for (var b = a.split(" "), c = [], d = 0; d < b.length; d++) c.push(new Cube.move(b[d]));
      return c
    },
    move: function(b) {
      this.face = b.substring(0, 1) || "U";
      var c = b.substring(1, 2);
      "" == c ? (this.move = 1, this.direction = 1) : "'" == c ? (this.move = 1, this.direction = -1) : "2" == c ? (this.move = 2, this.direction = 0) : (this.move = 1, this.direction = 1)
    },
    colors: ["U", "R", "F", "D", "L", "B"],
    facelets: ["U1", "U2", "U3", "U4", "U5", "U6", "U7", "U8", "U9", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9"],
    corners: ["URF", "UFL", "ULB", "URB", "RFD", "FDL", "DLB", "RDB"],
    edges: ["UR", "UF", "UL", "UB", "RD", "FD", "DL", "DB", "RF", "FL", "LB", "RB"],
    colorIndexes: {
      U: 0,
      R: 1,
      F: 2,
      D: 3,
      L: 4,
      B: 5
    },
    cubeToArr: function(a) {
      for (var b = [], c = 0; c < 6; c++) {
        b[c] = [];
        for (var d = 0; d < 3; d++) {
          b[c][d] = [];
          for (var e = 0; e < 3; e++) b[c][d][e] = a.charAt(9 * c + 3 * d + e)
        }
      }
      return b
    },
    arrToCube: function(a) {
      for (var b = "", c = 0; c < 6; c++)
      for (var d = 0; d < 3; d++)
      for (var e = 0; e < 3; e++) b += a[c][d][e];
      return b
    },
    getAdjacentFacelets: function(a, b, c) {
      for (var d = Cube.faceletToCubelet[a][b][c], e = [], f = 0; f < 6; f++)
      for (var g = 0; g < 3; g++)
      for (var h = 0; h < 3; h++) f == a && g == b && h == c || Cube.faceletToCubelet[f][g][h] != d || e.push([f, g, h]);
      return e
    },
    faceletToCubelet: [
      [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8]
      ],
      [
        [8, 5, 2],
        [17, 14, 11],
        [26, 23, 20]
      ],
      [
        [6, 7, 8],
        [15, 16, 17],
        [24, 25, 26]
      ],
      [
        [24, 25, 26],
        [21, 22, 23],
        [18, 19, 20]
      ],
      [
        [0, 3, 6],
        [9, 12, 15],
        [18, 21, 24]
      ],
      [
        [2, 1, 0],
        [11, 10, 9],
        [20, 19, 18]
      ]
    ],
    orderColors: function() {
      return Array.prototype.slice.call(arguments).sort(function(a, b) {
        return Cube.colorIndexes[a] < Cube.colorIndexes[b] ? -1 : Cube.colorIndexes[a] > Cube.colorIndexes[b] ? 1 : 0
      }).join("")
    },
    autocompleteCube: function(a) {
      return Cube.arrToCube(Cube.autocompleteArray(Cube.cubeToArr(a)))
    },
    autocompleteArray: function(a) {
      var c, b = a.slice();
      do c = b.slice(), b = Cube.autocompleteEdge(b); while (Cube.arrToCube(b) != Cube.arrToCube(c));
      do c = b.slice(), b = Cube.autocompleteCorner(b); while (Cube.arrToCube(b) != Cube.arrToCube(c));
      return b
    },
    autocompleteEdge: function(a) {
      for (var b = a.slice(), c = [], d = 0; d < 6; d++)
      for (var e = 0; e < 3; e++)
      for (var f = 1 - e % 2; f < 3; f += 2) {
        var g = b[d][e][f];
        if ("_" != g) {
          var h = Cube.getAdjacentFacelets(d, e, f)[0],
          i = b[h[0]][h[1]][h[2]];
          if ("_" != i) {
            var j = Cube.orderColors(g, i);
            c.indexOf(j) == -1 && c.push(j)
          }
        }
      }
      for (var d = 0; d < 6; d++)
      for (var e = 0; e < 3; e++)
      for (var f = 1 - e % 2; f < 3; f += 2) {
        var g = b[d][e][f];
        if ("_" == g) {
          var h = Cube.getAdjacentFacelets(d, e, f)[0],
          i = b[h[0]][h[1]][h[2]],
          j = Cube.orderColors(g, i);
          if ("_" != i) {
            for (var k = [], l = 0; l < Cube.colors.length; l++) {
              var m = Cube.colors[l],
              j = Cube.orderColors(i, m);
              Cube.edges.indexOf(j) != -1 && c.indexOf(j) == -1 && k.push(m)
            }
            1 == k.length && (b[d][e][f] = k[0])
          }
        }
      }
      return b
    },
    autocompleteCorner: function(a) {
      for (var b = a.slice(), c = [], d = 0; d < 6; d++)
      for (var e = 0; e < 3; e += 2)
      for (var f = 0; f < 3; f += 2) {
        var g = b[d][e][f];
        if ("_" != g) {
          var h = Cube.getAdjacentFacelets(d, e, f),
          i = b[h[0][0]][h[0][1]][h[0][2]],
          j = b[h[1][0]][h[1][1]][h[1][2]];
          if ("_" != i && "_" != j) {
            var k = Cube.orderColors(g, i, j);
            c.indexOf(k) == -1 && c.push(k)
          }
        }
      }
      for (var d = 0; d < 6; d++)
      for (var e = 0; e < 3; e += 2)
      for (var f = 0; f < 3; f += 2) {
        var g = b[d][e][f];
        if ("_" == g) {
          var h = Cube.getAdjacentFacelets(d, e, f),
          i = b[h[0][0]][h[0][1]][h[0][2]],
          j = b[h[1][0]][h[1][1]][h[1][2]],
          k = Cube.orderColors(g, i, j);
          if ("_" != i && "_" != j) {
            for (var l = [], m = 0; m < Cube.colors.length; m++) {
              var n = Cube.colors[m],
              k = Cube.orderColors(i, j, n);
              Cube.corners.indexOf(k) != -1 && c.indexOf(k) == -1 && l.push(n)
            }
            1 == l.length && (b[d][e][f] = l[0])
          }
        }
      }
      return b
    },
    reverseArray: function(a) {
      for (var b = Cube.movesetToArray(Cube.arrayToMoveset(a)).reverse(), c = 0; c < b.length; c++) b[c].direction = b[c].direction * -1;
      return b
    },
    arrayToMoveset: function(a, b) {
      for (var c = "", d = 0; d < a.length; d++) {
        var e = a[d];
        c += e.text, d != a.length - 1 && (c += b ? "_" : " ")
      }
      return c
    },
    validateMoveset: function(a) {
      return !!a.match(/^([ULFRBD](['2]|))( ([ULFRBD](['2]|)))*$/)
    },
    reverseMoveset: function(a) {
      return Cube.arrayToMoveset(Cube.reverseArray(Cube.movesetToArray(a)))
    },
    randomCube: function(a) {
      var b = function(c) {
        "random" == c.data.type && (a(c.data.result), Cube.worker.removeEventListener("message", b, !1))
      };
      Cube.worker.addEventListener("message", b, !1), Cube.worker.postMessage({
        type: "random"
      })
    },
    verifyCube: function(a, b) {
      var c = function(d) {
        "verify" == d.data.type && d.data.cube == a && (b(Math.abs(d.data.result)), Cube.worker.removeEventListener("message", c, !1))
      };
      Cube.worker.addEventListener("message", c, !1), Cube.worker.postMessage({
        type: "verify",
        cube: a
      })
    },
    solveCube: function(a, b, c, d, e, f, g) {
      if (!Cube.tablesGenerated) throw new Error("First the tables need to be generated!");
      var h = function(c) {
        if ("solution" == c.data.type && c.data.cube == a) {
          if (0 == c.data.result.indexOf("Error") && errorCallback) errorCallback(parseInt(c.data.result.substring(6, 7)));
          else {
            var e = c.data.result.substring(0, c.data.result.length - 1);
            b(d ? Cube.movesetToArray(e) : e)
          }
          Cube.worker.removeEventListener("message", h, !1)
        }
      };
      Cube.worker.addEventListener("message", h, !1);
      var i = {
        cube: a,
        maxDepth: e || 20,
        maxTime: f || 30,
        useSeparator: !!g,
        type: "solve"
      };
      Cube.worker.postMessage(i)
    },
    generateTables: function(a, b) {
      var c = function(d) {
        "progress" == d.data.type && b ? b(d.data.line, d.data.time) : "CoordCube" == d.data.type && (a(), Cube.tablesGenerated = !0, Cube.worker.removeEventListener("message", c, !1))
      };
      Cube.worker.addEventListener("message", c, !1), Cube.worker.postMessage({
        type: "generateTables"
      })
    }
  }, Object.defineProperty(Cube.move.prototype, "text", {
    get: function() {
      var a = this.face;
      return this.direction == -1 ? a += "'" : 2 == this.move && (a += "2"), a
    },
    set: function(a) {
      var b = a.substring(0, 1),
      c = a.substring(1, 2),
      d = 0;
      "" == c ? (c = 1, d = 1) : "'" == c ? (c = 1, d = -1) : "2" == c && (c = 2, d = 0), this.face = b, this.move = c, this.direction = d
    }
  }), Object.defineProperty(Cube.move.prototype, "toString", {
    value: function() {
      return this.text
    }
  })
}();
var cc, generateColorsString = function() {
  return "FFFF00FFFFFFFF0000FF80400000FF00FF00"
},
maxtime = 30,
maxmoves = 20,
worker = new Worker("RubikWorker.js"),
totalTime = 0,
facelets = ["U1", "U2", "U3", "U4", "U5", "U6", "U7", "U8", "U9", "R1", "R2", "R3", "R4", "R5", "R6", "R7", "R8", "R9", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "L1", "L2", "L3", "L4", "L5", "L6", "L7", "L8", "L9", "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9"],
colors = ["U", "L", "F", "R", "B", "D"],
colorNames = {
  U: "#FFFF0F",
  R: "#1D16DB",
  F: "#F7A000",
  L: "#299E05",
  D: "#FFFFFF",
  B: "#EB0000",
  _: "#BBBBBB"
},
times = {
  twistMove: 257,
  flipMove: 220,
  FRtoBR_Move: 1645,
  URFtoDLF_Move: 3189,
  URtoDF_Move: 2904,
  URtoUL_Move: 173,
  UBtoDF_Move: 185,
  MergeURtoULandUBtoDF: 2803,
  Slice_URFtoDLF_Parity_Prun: 3022,
  Slice_URtoDF_Parity_Prun: 2828,
  Slice_Twist_Prun: 2714,
  Slice_Flip_Prun: 2544
};
worker.addEventListener("message", function(a) {
  if ("message" == a.data.type) warning(" ", a.data.msg), console.log(a.data.msg);
  else if ("CoordCube" == a.data.type) {
    document.getElementById("bar").outerHTML = "Done in " + totalTime + "ms", document.getElementById("solve").disabled = !1, worker.postMessage({
      type: "solve",
      cube: document.getElementById("cube").value,
      maxDepth: megprobalKirakniEnnyiLepesben,
      maxTime: 30
    }), megprobalKirakniEnnyiLepesben = 24;
    var b = a.data.cc;
    for (var c in b) 0 == c.indexOf("Slice") && (b[c] = typedToArray(b[c]))
  } else if ("verify" == a.data.type)
  if (0 == a.data.result) console.log("Valid cube.");
  else {
    var d;
    switch (a.data.result) {
      case -1:
      d = "Each color must be added exactly 9 times";
      break;
      case -2:
      d = "Every edge must be added once";
      break;
      case -3:
      d = "An edge needs to be flipped";
      break;
      case -4:
      d = "Every corner must be added once";
      break;
      case -5:
      d = "A corner needs to be twisted";
      break;
      case -6:
      d = "Two corners or two edges need to be swapped";
      break;
      default:
      d = "Unknown error"
    }
    console.log("Invalid cube! " + a.data.result + ": " + d + ". "), warning("Invalid cube", a.data.result + ": " + d + ". <br />Close this window and check the cube!")
  }
  else if ("random" == a.data.type) document.getElementById("cube").value = a.data.result, setInput.apply(document.getElementById("cube"));
  else if ("progress" == a.data.type) {
    var e = document.createElement("li");
    totalTime += a.data.time, e.innerHTML = a.data.line + " Completed, Took " + a.data.time + "ms", document.getElementById("details").appendChild(e), document.getElementById("bar").value += times[a.data.line]
  } else if ("solution" == a.data.type)
  if (0 == a.data.result.indexOf("Error")) {
    var d, f = parseInt(a.data.result.substring(6, 7));
    switch (f) {
      case 1:
      d = "Each color must be added exactly 9 times";
      break;
      case 2:
      d = "Every edge must be added once";
      break;
      case 3:
      d = "An edge needs to be flipped";
      break;
      case 4:
      d = "Every corner must be added once";
      break;
      case 5:
      d = "A corner needs to be twisted";
      break;
      case 6:
      d = "Two corners or two edges need to be swapped";
      break;
      case 7:
      d = "Couldn't find a solution in " + maxmoves + " moves";
      break;
      case 8:
      d = "No solution found within " + maxtime + " seconds";
      break;
      default:
      d = "Unknown error"
    }
    console.log((f < 7 ? "Invalid Cube. " : "Solver ") + "  " + d + "."), f < 7 && (warning("Invalid Cube", d + ". <br />Close this window and check the&nbsp;cube!"), kiir()), f > 6 && (70 != megprobalKirakniEnnyiLepesben ? (console.log("Looking for solution in 24 steps."), worker.postMessage({
      type: "solve",
      cube: document.getElementById("cube").value,
      maxDepth: megprobalKirakniEnnyiLepesben,
      maxTime: 60
    }), megprobalKirakniEnnyiLepesben = 70) : warning("This is unusual...", "Sorry but we couldn't find the optimal solution in 2 minutes.<br />Please <a href=\"https://rubiks-cube-solver.com/layer-by-layer.php?cube=" + urlkocka + '&x=86">click here for a layer-by-layer</a> solution.'))
  } else {
    var g = Cube.movesetToArray(a.data.result);
    buildOutput(g), pushState()
  }
}, !1), worker.addEventListener("error", function(a) {
  console.log(a), warning("Error", a), a.preventDefault()
}, !1);
var currentColor = "F";
window.addEventListener("popstate", popState, !1);
var isRandom = !1;
document.addEventListener("DOMContentLoaded", function() {
  document.getElementById("generateButton").addEventListener("click", function() {
    worker.postMessage({
      type: "generateTables"
    }), document.getElementById("progress").hidden = !1, document.getElementById("generate").hidden = !0
  }, !1), document.getElementById("randomButton").addEventListener("click", function() {
    worker.postMessage({
      type: "random"
    }), isRandom = !0, pushState()
  }, !1), document.getElementById("maxmoves").addEventListener("input", function() {
    maxmoves = this.valueAsNumber
  }, !1), document.getElementById("maxtime").addEventListener("input", function() {
    maxtime = this.valueAsNumber
  }, !1), document.getElementById("verify").addEventListener("click", function() {
    worker.postMessage({
      type: "verify",
      cube: document.getElementById("cube").value
    })
  }, !1), document.getElementById("solve").addEventListener("click", function() {
    worker.postMessage({
      type: "solve",
      cube: document.getElementById("cube").value,
      maxDepth: maxmoves,
      maxTime: maxtime
    })
  }, !1);
  for (var a = document.getElementsByClassName("colorInput"), b = 0; b < a.length; b++) a[b].addEventListener("change", setColors, !1);
  document.getElementById("cube").addEventListener("input", setInput, !1), document.getElementById("clear").addEventListener("click", clearFacelets, !1), document.getElementById("clean").addEventListener("click", cleanCube, !1);
  for (var c = document.getElementById("entry"), b = 0; b < colors.length; b++) {
    var d = document.createElement("div");
    d.className = "side", d.id = colors[b], c.appendChild(d)
  }
  for (var b = 0; b < facelets.length; b++) {
    var d = document.createElement("div");
    "5" == facelets[b].substring(1, 2) ? d.className = "facelet center" : (parseInt(facelets[b].substring(1, 2)) - 1) % 3 == 0 && "9" != facelets[b].substring(1, 2) ? d.className = "facelet right" : d.className = "facelet", d.id = facelets[b], d.color = facelets[b].substring(0, 1), d.style.backgroundColor = colorNames[d.color], d.addEventListener("click", setColor, !1);
    var e = document.getElementById(facelets[b].substring(0, 1));
    e.appendChild(d)
  }
  if (document.getElementById("currentColor").addEventListener("click", setColorBlank, !1), "" != window.location.search) {
    var f = getQueryString(window.location.search.substring(1)),
    g = {
      state: f
    };
    popState(g)
  } else {
    var g = {
      state: {
        cube: "clear"
      }
    };
    popState(g)
  }
  document.getElementById("currentColor").style.backgroundColor = colorNames[currentColor]
}, !1);
var mouseX = 0,
mouseY = 0,
poppedUp = 0,
eltelt5mp = 0;
document.addEventListener("mousemove", function(a) {
  mouseX = a.clientX, mouseY = a.clientY
}), jQuery(document).mouseleave(function() {
  $("#alertBox").length > 0 && mouseY < 100 && 0 == poppedUp && 1 == eltelt5mp && (jQuery("#alertBox").fadeIn(200), jQuery("#alertShadow").fadeIn(200), document.getElementById("alertBoxContent").innerHTML = '<iframe src="https://rubiks-cube-solver.com/likebox.html" width="300" height="300" scrolling="no">Iframes not supported</iframe>', document.getElementById("callToAddThis2").innerHTML = document.getElementById("callToAddThis").innerHTML, poppedUp++)
}), $(document).ready(function() {
  setTimeout(function() {
    eltelt5mp = 1
  }, 5e3), $("#alertBoxClose,#alertShadow").click(function(a) {
    $("#alertBox").fadeOut(), $("#alertShadow").fadeOut(200)
  })
});
