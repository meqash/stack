subroutine S_trans(sig,nsamp,nn,n21,npow,cyc,dt,ctf)
!parameter (nsmax=16384,nsctf=16384,nfctf=8192)
parameter (nsmax=8192,nsctf=8192,nfctf=4096)
real sig(nsmax),dt
real pi,fact,cyc,freq
complex cdum(nsctf)
complex csig(nsctf),ctf(nsctf,nfctf)
integer npow,nn,n21,nsmp,nsamp,i,j
pi=4.0*atan(1.0)
fact=cyc/2.0
csig=cmplx(0.0d0,0d0)
csig(1:nsamp)=cmplx(sig(1:nsamp),0.0)
call clogc(npow,csig,1,dt)    ! do fft
pp=-2.0*pi*pi*fact*fact
ctf(:,1)=cmplx(0.0,0.0)
do nf=2,n21+1                 ! loop over frequency
   nf1=nf-1
   cdum=cmplx(0.0,0.0)
   rpp=pp/float(nf1)/float(nf1)
   do mf=1,nn
      rmf=float(mf)
      rns=float(nn-mf+1)
      argp=rpp*rmf*rmf
      argn=rpp*rns*rns
      if (argp.gt.-25.or.argn.gt.-25) then
         mn=mf+nf1
         if(mn.gt.nn)mn=mn-nn
         rr=exp(argp)+exp(argn)
         cdum(mf)=csig(mn)*rr
      endif
   enddo
   call clogc(npow,cdum,-1,dt)
   ctf(1:nsamp,nf)=cdum(1:nsamp)
enddo
return
end subroutine
