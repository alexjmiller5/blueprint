local M = {}
M.profileName = "Work"
-- Application Bundle IDs
M.appBundleIds = {
  gemini         = "com.google.Chrome.app.caidcmannjgahlnhpmdmihecjcoiigg",
  youtube        = "com.google.Chrome.app.agimnkijcaahngcdmfeangaknmldooml",
  googleTasks    = "com.google.Chrome.app.okhfeehhillipaleckndoboggdkcebmo",
  googleCalendar = "com.google.Chrome.app.kjbdgfilnfhdofibpgamdcdgpehopbep",
  gmail          = "com.google.Chrome.app.fmgjjmmmlfnkbppncabfkddbjimcfncm",
  googleDrive    = "com.google.Chrome.app.aghbiahbpaijignceidepookljebhfak",
}

M.paths = {
  clickMyDrive               = M.home .. "/.local/bin/click-my-drive-button.applescript",
  openGooglePasswordsManager = M.home .. "/.local/bin/open-google-passwords-manager.applescript",
  artifactoryRepo            = M.home ..
  "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Desktop/repos/Artifactory-Artifactory",
  driveDesktop               = M.home ..
  "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Desktop",
  driveDownloads             = M.home ..
  "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Downloads",
  driveDocuments             = M.home ..
  "/Library/CloudStorage/GoogleDrive-alexander.miller@capitalone.com/My Drive/Documents",
}

return M
