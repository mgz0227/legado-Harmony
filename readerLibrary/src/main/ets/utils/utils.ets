
class Gson {
  toString<T>(info?: T): string | undefined {
    if (!info) {
      return undefined;
    }
    return JSON.stringify(info)
  }

  toJson<T>(json?: string): T | undefined {
    if (!json) {
      return undefined;
    }
    try {
      return JSON.parse(json) as T;
    } catch (error) {
      return undefined;
    }
  }
}
export const GSON = new Gson();