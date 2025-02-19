#pragma once

#include <drogon/HttpController.h>
#include <drogon/plugins/PromExporter.h>

using namespace drogon;

namespace demo
{
  namespace v1
  {
    class Device : public drogon::HttpController<Device>
    {
    public:
      METHOD_LIST_BEGIN

      ADD_METHOD_TO(Device::get, "/api/devices", Get);
      ADD_METHOD_TO(Device::health, "/healthz", Get);

      METHOD_LIST_END

    private:
      void health(const HttpRequestPtr &req, std::function<void(const HttpResponsePtr &)> &&callback);

      void get(const HttpRequestPtr &req, std::function<void(const HttpResponsePtr &)> &&callback);
    };
  }
}
