import { Body, Controller, Get, Param, Post, Req, UseGuards } from '@nestjs/common';
import { AuthService } from './auth.service';
import { CreateUserDto } from '../users/dto/create-user.dto';
import { JwtAuthGuard } from '../jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private authservice: AuthService) {}
  @UseGuards(JwtAuthGuard)
  @Post('register')
  async regsiter(@Body() createUserDto: CreateUserDto,@Req() req) {
    return this.authservice.register(createUserDto, req.user);
  }

  @Post('login')
  async login(@Body('username') username: string, @Body('password') password: string) {
    return this.authservice.login(username, password);
  }

  @Get('username/:username')
  findOne(@Param('username') username: string) {
    return this.authservice.findOneByusername(username);
  }

  @Get('all')
  findAllUser() {
    return this.authservice.findAllUser();
  }
}
