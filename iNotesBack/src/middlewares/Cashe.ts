import {Request, Response, NextFunction} from "express";

interface CacheItem {
    data: any;
    expiry: number;
}

class CacheService {
    private cache: Map<string, CacheItem>;
    private readonly defaultTTL: number;

    constructor(defaultTTL = 60000) {
        this.cache = new Map();
        this.defaultTTL = defaultTTL;
    }

    set(key: string, data: any, ttl = this.defaultTTL): void {
        const expiry = Date.now() + ttl;
        this.cache.set(key, {data, expiry});
    }

    get(key: string): any | null {
        const item = this.cache.get(key);
        if (!item) {
            return null;
        }

        if (Date.now() > item.expiry) {
            this.cache.delete(key);
            return null;
        }

        return item.data;
    }

    delete(key: string): void {
        this.cache.delete(key);
    }

    cleanup(): void {
        const now = Date.now();
        for (const [key, item] of this.cache.entries()) {
            if (now > item.expiry) {
                this.cache.delete(key);
            }
        }
    }

    generateKey(req: Request): string {
        const url = req.originalUrl || req.url;
        const method = req.method;
        return `${method}-${url}`;
    }
}

const cacheService = new CacheService();

setInterval(() => {
    cacheService.cleanup();
}, 300000);

const Cache = (ttl?: number) => {
    return (req: Request, res: Response, next: NextFunction): void => {
        if (req.method !== 'GET') {
            next();
            return;
        }

        const key = cacheService.generateKey(req);
        const cachedData = cacheService.get(key);

        if (cachedData) {
            res.json(cachedData);
            return;
        }

        const originalJson = res.json;

        res.json = function (data) {
            res.json = originalJson;

            cacheService.set(key, data, ttl);

            return originalJson.call(this, data);
        };

        next();
    };
};

export { Cache, cacheService };
