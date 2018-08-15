#include <string>
#include <yaml-cpp/yaml.h>

using namespace std;

int main(int argc, char** argv) {
  string yaml_path = argv[1];
  try {
    YAML::Node config = YAML::LoadFile(yaml_path);
    for (auto it1 = config.begin(); it1 != config.end(); ++it1) {
      string key = it1->first.as<string>();
      YAML::Node node = it1->second;

      if (node.IsMap()) {
        cout << key << ": " << endl;
        for (auto it2 = node.begin(); it2 != node.end(); ++it2) {
          cout << "  " << it2->first.as<string>() << ": " << endl;
          auto items = it2->second;
          cout << "    url_base: " << items["url_base"].as<string>() << endl;
          cout << "    parser: " << items["parser"].as<string>() << endl;
        }

      } else if (node.IsSequence()) {
        cout << key << ": ";
        for (size_t i = 0; i < node.size(); i++) {
          cout << node[i].as<string>() << " ";
        }
        cout << endl;

      } else if (node.IsScalar()) {
        if (key == "default_timeout") {
          cout << key << ": " << node.as<string>() << endl;
        } else {
          cout << key << ": " << node.as<int>() << endl;
        }

      } else {
        cerr << "Unknown type in " << key << endl;
      }
    }
  } catch (YAML::Exception& e) {
    cerr << e.what() << endl;
  }
  return 0;
}
