#include <stdio.h>
#include <string.h>

#define STACK_MAX_SIZE 256
#define NO_EXPAND(a) #a
#define STR(a) NO_EXPAND(a)

#define FIND_CONFIG(ConfigPath) STR(CONFIG_PATH) ConfigPath
#define FIND_ASSET(AssetPath) STR(CONTENT_PATH) AssetPath

void LoadConfig(const char *ConfigPath) {
  char absPath[STACK_MAX_SIZE] = STR(CONFIG_PATH);
  strcat(absPath, ConfigPath);
  printf("CONFIG:%s\n", absPath);
}

void LoadAsset(const char *AssetPath) {
  char absPath[STACK_MAX_SIZE] = STR(CONTENT_PATH);
  strcat(absPath, AssetPath);
  printf("ASSET:%s\n", absPath);
}

int main(int argc, const char **argv) {
  const char* configPath = FIND_CONFIG("Settings/GameSettings.txt");
  const char* assetPath = FIND_ASSET("Texture/Player/Player.bmp");
  printf("Config Path:%s\n", configPath);
  LoadConfig("Settings/GameSettings.txt");
  printf("Asset Path:%s\n", assetPath);
  LoadAsset("Texture/Player/Player.bmp");

  return 0;
}
