import { Response } from 'express';
export declare class FileController {
    getFile(filename: string, res: Response): Promise<void | Response<any, Record<string, any>>>;
}
